# frozen_string_literal: true

module Export
  class << self
    def to_csv(source, response = {})
      table = "ctfc_#{response[:fiat]}_#{source}.csv"
      coins = response[:coins]
      data_row = price_array_from response
      create_csv_headers(table, coins) unless File.exist?(table)
      CSV.open(table, 'ab') { |column| column << data_row }
    end

    def to_json(source, response = {})
      table = "ctfc_#{response[:fiat]}_#{source}.json"
      data = JSON.pretty_generate(response[:data])
      File.write(table, data)
    end

    def all(*args)
      to_csv(*args)
      to_json(*args)
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
