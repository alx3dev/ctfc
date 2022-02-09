# frozen_string_literal: true

module API
  class Cryptocompare < ApiTemplate

    private

    def process(fiat, coins)
      coins.collect do |coin|
        @response[:uri] += "fsyms=#{coin}&"
      end
      request = RestClient.get @response[:uri]
      data = JSON.parse request
      process_json_data fiat, coins, data
    end

    def process_json_data(fiat, coins, data)
      @response[:data] = data
      @response[:data_row] = [Time.now.to_s]
      coins.each do |coin|
        value = data['RAW'][coin.upcase][fiat.name.upcase]['PRICE'].round(2)
        @response[:prices][coin] = value
        @response[:data_row] << value
      end
      @response
    rescue StandardError
      if (@response[:counter] += 1) > MAX_RETRY
        puts @response[:data].to_s.split(',')
        false
      else
        process_json_data fiat, coins, data
      end
    end

  end
end
