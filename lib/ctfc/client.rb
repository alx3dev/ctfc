# frozen_string_literal: true

require_relative 'api'
require_relative 'export'

module CTFC
  #
  # Client allow us to get data from our sources, and to
  # manipulate with that data. While other classes are mostly
  # used by each-other, Client is mostly used directly by user.
  #
  class Client
    attr_reader :config, :response, :prices

    #
    # Choose fiat currency, coins and source for new client.
    # @example Initialize new **EUR** client
    #  client = CTFC::Client.new :eur, %w[BTC XMR LTC ETH]
    #
    # @param [Symbol] currency **Required**. Set fiat currency.
    # @param [Array] coins **Required**. Set crypto coins.
    # @param [Symbol] source Optional. Source for data extraction.
    # @param [Hash] opts Options hash for additional configuration.
    #
    # @option opts [Symbol] source Set source to extract data.
    # @option opts [Boolean] save Set option to save prices in csv table.
    # @option opts [Boolean] export Set option to export all data in json file.
    #
    # @return [Client] Client instance.
    #
    def initialize(fiat, coins, source = nil, opts = {})
      @config = {
        fiat: fiat,
        coins: coins,
        source: source || opts[:source],
        save: [nil, true].include?(opts[:save]),
        export: opts[:export].is_a?(TrueClass)
      }
    end

    # Scrap data from source.
    # @example
    #  client.get :cryptocompare
    #
    # @param [Symbol] source Source to send api request
    # @return [Hash] Hash of fiat values for scrapped coins
    #
    def get(source = nil)
      source ||= config[:source]
      send_api_request(source)
      if success?
        Export.to_csv(source, response) if save?
        Export.to_json(source, response) if export?
      end
      @prices = response[:prices]
    end

    # Source for data extraction.
    # @return [Symbol]
    #
    def source
      config[:source]
    end

    # Set source for data extraction.
    # @return [Symbol]
    #
    def source=(param)
      @config[:source] = param
    end

    # Check if csv output will be saved after request.
    # @return [Boolean]
    #
    def save?
      config[:save].is_a?(TrueClass)
    end

    # Change option to save prices in csv table after request.
    # @return [Boolean]
    #
    def save=(opt)
      @config[:save] = opt.is_a?(TrueClass)
    end

    # Check if json output will be exported after request.
    # @return [Boolean]
    #
    def export?
      config[:export].is_a?(TrueClass)
    end

    # Change option to export all data in json file after request.
    # @return [Boolean]
    #
    def export=(opt)
      @config[:export] = opt.is_a?(TrueClass)
    end

    # Get fiat value from response hash with crypto prices
    # @example
    #  client.price(:btc)
    #
    # @param [Symbol] coin **Required**. Coin name as symbol.
    # @return [Float]
    #
    def price(coin)
      prices[coin.to_s.upcase]
    end

    # Check if request was successful.
    #
    def success?
      return false if response.nil?

      response[:success].is_a?(TrueClass)
    end

    private

    def send_api_request(source)
      # automatically add new sources to the client, but be careful with eval.
      if List.sources.include? source
        klass = check_source_name source

        @response =
          instance_eval "CTFC::API::#{klass}[ config[:fiat], config[:coins] ]"\
                        '# CTFC::API::Cryptocompare[fiat, coins]', __FILE__, __LINE__ - 1
      else
        message = 'Add source to extract data' if source.nil?
        message = "#{source} not included in API list" if source
        raise ArgumentError, message
      end
    end

    # Check for underscore and capitalize each word.
    #
    def check_source_name(source)
      if source.to_s.include? '_'
        source.split('_').select(&:capitalize!).join
      else
        source.to_s.capitalize
      end
    end
  end
end
