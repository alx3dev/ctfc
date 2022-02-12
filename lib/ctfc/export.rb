# frozen_string_literal: true

module Export
  class << self
    def to_csv(response = {})
      table = "ctfc_#{response[:fiat]}_#{response[:source]}.csv"
      coins = response[:coins]
      data_row = price_array_from response
      create_csv_headers(table, coins) unless File.exist?(table)
      CSV.open(table, 'ab') { |column| column << data_row }
    end

    private

    def create_csv_headers(table, coins)
      header_array = ['TIME']
      coins.each { |coin| header_array << coin }
      CSV.open(table, 'w') { |header| header << header_array }
    end

    def price_array_from(response = {})
      price_array = [response[:time_at]]
      response[:prices].each do |_coin, price|
        price_array << price
      end
      price_array
    end
  end
end
