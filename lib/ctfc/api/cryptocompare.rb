# frozen_string_literal: true

require_relative 'apitemplate'

module API
  class Cryptocompare < ApiTemplate
   class << self

    def [](fiat, coins)
      # load template attributes and send request
      request = prepare_response_hash fiat, coins, :cryptocompare
      request.response
    end

    private

    def process(fiat = response[:fiat], coins = response[:coins])
      super
      coins.collect { |coin| @response[:uri] += "fsyms=#{coin}&" }
      request = RestClient.get response[:uri]
      data = JSON.parse request
      process_json_data fiat, coins, data
    end

    def process_json_data(fiat, coins, data)
      prices, time_at = {}, Time.now.to_s
      coins.each do |coin|
        value = data['RAW'][coin.upcase][fiat.name.upcase]['PRICE'].round(2)
        prices[coin] = value
      end
      @response.merge! time_at: time_at, data: data, prices: prices
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
end
