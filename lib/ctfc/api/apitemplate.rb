# frozen_string_literal: true

module CTFC
  module API
    class ApiTemplate
      MAX_RETRY = 3
      BASE_URL = {
        cryptocompare: 'https://min-api.cryptocompare.com/data/pricemultifull?',
        kraken: '',
        binance: '' }.freeze

      attr_reader :response

      def initialize(fiat, coins)
        @response = { fiat: fiat, coins: coins, uri: BASE_URL[source] }
        process fiat, coins
      end

      def go
        process
      end

      private

      def process(fiat = response[:fiat], coins = response[:coins])
        return false unless fiat && coins
      end

      def save_csv_data(table, data_row, coins)
        return unless save?

        create_csv_headers(table, coins) unless File.exist?(table)
        CSV.open(table, 'ab') { |column| column << data_row }
      end

      def create_csv_headers(table, coins)
        header_array = ['TIME']
        coins.each { |coin| header_array << coin }
        CSV.open(table, 'w') { |header| header << header_array }
      end

    end
  end
end
