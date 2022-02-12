# frozen_string_literal: true

module CTFC
  module API
    class ApiTemplate
      attr_reader :response, :counter

      MAX_RETRY = 3
      BASE_URL = {
        cryptocompare: 'https://min-api.cryptocompare.com/data/pricemultifull?',
        kraken: '',
        binance: ''
      }.freeze

      def initialize(fiat, coins, source)
        @counter = 0
        @response = { fiat: fiat,
                      coins: coins,
                      uri: BASE_URL[source] }
        process
      end

      private

      # @todo api key support
      # @todo proxy support
      def process
        return false unless response[:fiat] && response[:coins]
      end
    end
  end
end
