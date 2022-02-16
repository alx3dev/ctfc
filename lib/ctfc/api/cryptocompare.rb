# frozen_string_literal: true

require_relative 'apitemplate' unless defined? CTFC::API::ApiTemplate

module CTFC
  module API
    # Source file for cryptocompare api.
    # Initialize will automatically call #process,
    # to send request after all attributes and variables are configured.
    #
    # @see CTFC::API::ApiTemplate
    #
    class Cryptocompare < ApiTemplate
      # Cryptocompare API base url, where we add coins and fiat currency.
      BASE_URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'

      private

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

      def do_rest_request(time = Time.now)
        rest = RestClient.get(response[:uri])
        success! if rest.code == 200
        process_json_data JSON.parse(rest), time
      rescue StandardError => e
        success! set: false
        if (@counter += 1) > MAX_RETRY
          puts e.message
        else
          retry
        end
      end

      def process_json_data(data, time)
        fiat = response[:fiat]
        prices = {}
        response[:coins].each do |coin|
          value = data['RAW'][coin.upcase][fiat.to_s.upcase]['PRICE'].round(2)
          prices[coin] = value
        end
        @response.merge!(time: time.to_s, prices: prices, data: data)
      end
    end
  end
end
