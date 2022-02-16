# frozen_string_literal: true

# Keep methods to export data as csv or json.
# JSON extract all data, while CSV only save prices.
#
module Export
  class << self
    #
    # Save crypto prices in csv table.
    #
    def to_csv(source, response = {})
      table = "ctfc_#{response[:fiat]}_#{source}.csv"
      coins = response[:coins]
      data_row = price_array_from response
      create_csv_headers(table, coins) unless File.exist?(table)
      CSV.open(table, 'ab') { |column| column << data_row }
    end

    # Extract all data in json file.
    #
    def to_json(source, response = {})
      table = "ctfc_#{response[:fiat]}_#{source}.json"
      File.open(table, 'ab') do |append|
        append.puts JSON.pretty_generate response
      end
    end

    private

    def create_csv_headers(table, coins)
      header_array = ['TIME']
      coins.each { |coin| header_array << coin }
      CSV.open(table, 'w') { |header| header << header_array }
    end

    def price_array_from(response = {})
      price_array = [response[:time]]
      response[:prices].each do |_coin, price|
        price_array << price
      end
      price_array
    end
  end
end
