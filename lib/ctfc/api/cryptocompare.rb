# frozen_string_literal: true

require_relative 'apitemplate'

module CTFC
  module API
    class Cryptocompare < ApiTemplate
      def self.[](fiat, coins)
        new(fiat, coins).response
      end

      def initialize(fiat, coins)
        super fiat, coins, :cryptocompare
      end

      private

      def process
        super
        uri = response[:uri]
        fiat = response[:fiat]
        coins = response[:coins]
        coins.collect do |coin|
          uri += "fsyms=#{coin}&" unless uri.include? coin
        end
        uri += "tsyms=#{fiat}" unless uri.include? fiat
        time = Time.now.to_s
        request = RestClient.get uri
        data = JSON.parse request
        process_json_data fiat, coins, data, time
      rescue StandardError => e
        if (@counter += 1) > MAX_RETRY
          puts e.message
          @counter = 0
          false
        else
          retry
        end
      end

      def process_json_data(fiat, coins, data, time_at)
        prices = {}
        coins.each do |coin|
          value = data['RAW'][coin.upcase][fiat.upcase]['PRICE'].round(2)
          prices[coin] = value
        end
        @response.merge! time_at: time_at, data: data, prices: prices
      end
    end
  end
end
