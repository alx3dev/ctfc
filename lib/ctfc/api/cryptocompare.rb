# frozen_string_literal: true

require_relative 'apitemplate'

module CTFC
  module API
    # Source file for cryptocompare api.
    # Initialize will automatically call #process,
    # to send request after all settings are configured.
    #
    # @see CTFC::API::ApiTemplate
    #
    class Cryptocompare < ApiTemplate
      # Cryptocompare API base url, where we add coins and fiat currency.
      BASE_URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'

      private

      # Send API request. Automatically called on initialization,
      # to scrap data from source.
      def process
        super
        uri = ''
        response[:coins].collect do |coin|
          uri += "fsyms=#{coin}&" unless uri.include? coin
        end
        uri += "tsyms=#{response[:fiat]}"
        @response[:uri] = BASE_URL + uri
        do_rest_request
      end

      def do_rest_request(time = Time.now.to_s)
        rest = RestClient.get response[:uri]
        process_json_data JSON.parse(rest), time
      rescue StandardError => e
        request_fail!
        if (@counter += 1) > MAX_RETRY
          puts e.message
          @counter = 0
        else
          retry
        end
      end

      def process_json_data(data, time_at)
        fiat = response[:fiat]
        prices = {}
        response[:coins].each do |coin|
          value = data['RAW'][coin.upcase][fiat.upcase]['PRICE'].round(2)
          prices[coin] = value
        end
        @response.merge!(time_at: time_at, data: data,
                         prices: prices, success: true)
      end
    end
  end
end
