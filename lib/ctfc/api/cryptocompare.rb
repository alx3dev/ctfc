# frozen_string_literal: true

require_relative 'apitemplate'

module CTFC
  module API
    # Source file for cryptocompare api.
    class Cryptocompare < ApiTemplate
      # Cryptocompare API base url, where we add coins and fiat currency.
      BASE_URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'

      # Initialize new instance, send request and return response hash.
      # @example
      #  Cryptocompare[:eur, %w[BTC XMR]]
      #
      # @param [Symbol] fiat **Required**. Fiat currency.
      # @param [Array] coins **Required**. Cryptocurrency coins.
      #
      # @return [Hash] Response hash object.
      #
      def self.[](fiat, coins)
        new(fiat, coins).response
      end

      # Initialize will automatically call #process
      # to send request after all settings are configured.
      #
      # @example Send request to cryptocompare
      #  crypto = Cryptocompare.new :eur, %w[BTC XMR]
      #
      # @param [Symbol] fiat **Required**. Fiat currency.
      # @param [Array] coins **Required**. Cryptocurrency coins.
      #
      # @return [Object] Cryptocompare instance.
      #
      def initialize(fiat, coins)
        super fiat, coins, :cryptocompare
      end

      # Repeat request to cryptocompare api
      # @example Repeat request
      #  crypto.get
      #
      def get
        do_rest_request
      end

      private

      def process
        super
        uri = ''
        response[:coins].collect do |coin|
          uri += "fsyms=#{coin}&" unless uri.include? coin
        end
        uri += "tsyms=#{response[:fiat]}"
        @response[:uri] = BASE_URL + uri
        do_rest_request
      end

      def do_rest_request
        time = Time.now.to_s
        rest = RestClient.get response[:uri]
        data = JSON.parse rest
        process_json_data data, time
      rescue StandardError => e
        success! set: false
        if (@counter += 1) > MAX_RETRY
          puts e.message
          @counter = 0
        else
          retry
        end
      end

      def process_json_data(data, time_at)
        fiat = response[:fiat]
        prices = {}
        response[:coins].each do |coin|
          value = data['RAW'][coin.upcase][fiat.upcase]['PRICE'].round(2)
          prices[coin] = value
        end
        success!
        @response.merge! time_at: time_at, data: data, prices: prices
      end
    end
  end
end
