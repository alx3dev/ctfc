# frozen_string_literal: true

module CTFC
  module API
    class ApiTemplate
      class << self

        attr_reader :response

        MAX_RETRY = 3
        BASE_URL = {
          cryptocompare: 'https://min-api.cryptocompare.com/data/pricemultifull?',
          kraken: '',
          binance: '' }.freeze

        def prepare_response_hash(fiat, coins, source)
          @response = { fiat: fiat, coins: coins, uri: BASE_URL[source] }
          process fiat, coins
        end


        private

        def process(fiat = response[:fiat], coins = response[:coins])
          return false unless fiat && coins
          # to-do: check for api key before sending request
        end

      end
    end
  end
end
