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

    attr_reader   :response, :prices, :save
    attr_accessor :fiat, :coins, :source

    alias currency fiat

    def self.to(*args)
      new(*args).get
    end

    # Choose fiat currency, coins and source for new client.
    # @example Initialize new **EUR** client
    #  client = CTFC::Client.new :eur, coins: %w[BTC XMR LTC ETH]
    #
    # @param [Symbol] currency **Required**. Set fiat currency
    # @param [Hash] opts Options hash for additional configuration.
    #
    # @option opts [Array] coins Set default coins to scrap.
    # @option opts [Symbol] source Set source to scrap data.
    # @option opts [Boolean] save Set option to export data to file.
    #
    def initialize(fiat, opts = {})
      @fiat   = fiat.to_s.upcase
      @save   = opts[:save]   || true
      @coins  = opts[:coins]  || %w[BTC XMR LTC ETH]
      @source = opts[:source] || :cryptocompare
    end

    # Scrap data from source.
    # @example
    #  client.get :cryptocompare
    #
    # @param [Symbol] source Source to send api request
    # @return [Hash] Hash of fiat values for scrapped coins
    #
    def get(source = @source)
      send_api_request(source)
      Export.to_csv(source, response) if save?
      @prices = response[:prices]
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

    # Check if output will be saved after request.
    # @return [true || false]
    #
    def save?
      @save == true
    end

    # Change option to save output after request.
    # @return [true || false]
    #
    def save=(opt)
      @save = opt.is_a?(TrueClass)
    end

    # Check if request was successful.
    #
    def success?
      response[:success] == true
    end

    private

    # Send api request based on source
    #
    def send_api_request(source)
      @response =
        case source
        when :cryptocompare
          Cryptocompare[fiat, coins]
        when :binance
          # Binance[fiat, coins]
          raise NoMethodError, 'Working on Binance implementation'
        else
          raise NoMethodError, 'Not implemented, yet! Feel free to contribute!'
        end
    end
  end
end
