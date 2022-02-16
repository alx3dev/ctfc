# frozen_string_literal: true

module CTFC
  module API
    # Template for other sources. Every file in api dir should extend this class.
    # Automatically call method #process to send api request after initialization.
    # This mean every source should include #process method, that will be executed
    # after initialization.
    #
    # @see CTFC::API::Cryptocompare
    #
    class ApiTemplate
      attr_reader :response

      # max number of requests to send
      MAX_RETRY = 3

      # Construct response hash from given arguments, and start counting requests.
      # Call private method #process to extract data from web.
      #
      # @example Send request to cryptocompare
      #  crypto = Cryptocompare.new :eur, %w[BTC XMR]
      #
      # @param [Symbol] fiat **Required**. Fiat currency to convert coin price.
      # @param [Array] coins **Required**. Array of coins to scrap data for.
      #
      # @return [Object] Source instance.
      #
      def initialize(fiat, coins)
        @response = { fiat: fiat, coins: coins, success: false }
        @counter  = 0
        process
      end

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

      private

      def process
        return false unless response[:fiat] && response[:coins]
      end

      def success!(set: true)
        @counter = 0 if set == true
        @response[:success] = set
      end
    end
  end
end
