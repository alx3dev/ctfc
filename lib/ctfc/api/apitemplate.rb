# frozen_string_literal: true

module CTFC
  module API
    class ApiTemplate
      attr_reader :response

      MAX_RETRY = 3
      BASE_URL = {
        cryptocompare: 'https://min-api.cryptocompare.com/data/pricemultifull?',
        kraken: '',
        binance: ''
      }.freeze

      # use hash shortcut in ruby >= 3.1
      def initialize(fiat, coins, source)
        @response = { fiat: fiat,
                      coins: coins,
                      counter: 0,
                      success: false,
                      uri: BASE_URL[source] }
        process
      end

      private

      # @todo api key support
      # @todo proxy support
      def process
        return false unless response[:fiat] && response[:coins]
      end

      def success!(set: true)
        set = false unless set == true
        @response[:success] = set
      end
    end
  end
end
