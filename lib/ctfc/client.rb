# frozen_string_literal: true

require_relative 'export'
require_relative 'api'
require_relative 'version'

require 'json'
require 'csv'
require 'rest-client'

module CTFC
  #
  # Initialize client to set configuration, and get data from source.
  #
  class Client
    include CTFC::API

    attr_reader :config, :response, :prices

    def self.to(*args)
      new(*args).get
    end

    # Choose fiat currency, coins and source for new client.
    # @example Initialize new **EUR** client
    #  client = CTFC::Client.new :eur, %w[BTC XMR LTC ETH]
    #
    # @param [Symbol] currency **Required**. Set fiat currency
    # @param [Array] coins **Required**. Set crypto coins.
    # @param [Symbol] source Optional. Source for data extraction.
    # @param [Hash] opts Options hash for additional configuration.
    #
    # @option opts [Symbol] source Set source to extract data.
    # @option opts [Boolean] save Set option to export data to file.
    #
    # @return [Client] Client instance.
    #
    def initialize(fiat, coins, source = nil, opts = {})
      @config = {
        fiat: fiat,
        coins: coins,
        source: source || opts[:source],
        save: [nil, true].include? opts[:save]
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
      Export.to_csv(source, response) if save?
      Export.to_json(source, response) if export?
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
    # @return [true || false]
    #
    def save?
      config[:save] == true
    end

    # Change option to save csv output after request.
    # @return [true || false]
    #
    def save=(opt)
      @config[:save] = opt.is_a?(TrueClass)
    end

    # Check if json output will be exported after request.
    # @return [true || false]
    #
    def export?
      config[:export] == true
    end

    # Change option to save csv output after request.
    # @return [true || false]
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
      response[:success] == true
    end

    private

    def send_api_request(source)
      fiat = config[:fiat]
      coins = config[:coins]
      @response = case source
                  when :cryptocompare
                    Cryptocompare[fiat, coins]
                  else
                    raise NoMethodError, 'Not implemented, yet! ' \
                                         'Feel free to contribute!'
                  end
    end
  end
end
