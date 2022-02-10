# frozen_string_literal: true

module API
  class Cryptocompare < ApiTemplate

    def self.[](fiat, coins)
      result = new fiat, coins
      result.response
    end

    def initialize(fiat, coins)
      super fiat, coins
    end

    private

    def process(fiat = response[:fiat], coins = response[:coins])
      coins.collect do |coin|
        @response[:uri] += "fsyms=#{coin}&"
      end
      request = RestClient.get response[:uri]
      data = JSON.parse request
      process_json_data fiat, coins, data
    end

    def process_json_data(fiat, coins, data)
      prices, data_row = {}, [Time.now.to_s]
      coins.each do |coin|
        value = data['RAW'][coin.upcase][fiat.name.upcase]['PRICE'].round(2)
        prices[coin] = value
        data_row << value
      end
      @response = { data: data, data_row: data_row, prices: prices }
    rescue StandardError
      if (@response[:counter] += 1) > MAX_RETRY
        puts response[:data].to_s.split(',')
        false
      else
        process_json_data fiat, coins, data
      end
    end

  end
end
