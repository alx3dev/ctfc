# frozen_string_literal: true

module API
  class Cryptocompare
    BASE_URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'
    MAX_RETRY = 3

    def initialize(fiat, coins)
      @response = { counter: 0 }
      call_cryptocompare fiat, coins
    end

    private

    def call_cryptocompare(fiat, coins)
      price_hash, coin_uri = {}, ''
      coins.collect do |coin|
        coin_uri += "fsyms=#{coin}&"
      end
      request = RestClient.get(BASE_URL + "#{coin_uri}tsyms=#{fiat}")
      data = JSON.parse request
      process_json_data fiat, coins, data
    end

    def process_json_data(fiat, coins, data)
      @response[:data] = data
      @response[:data_row] = [Time.now.to_s]
      coins.each do |coin|
        value = data['RAW'][coin.upcase][fiat.name.upcase]['PRICE'].round(2)
        price_hash[coin] = value
        @response[:data_row] << value
      end
      @response[:prices] = price_hash
      @response
    rescue StandardError
      if (@response[:counter] += 1) > MAX_RETRY
        puts @response[:data].to_s.split(',')
        false
      else
        process_json_data fiat, coins, url
      end
    end

  end
end
