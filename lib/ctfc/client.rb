# frozen_string_literal: true

require_relative 'export'
require_relative 'api'
require_relative 'version'

require 'json'
require 'csv'
require 'kolorit'
require 'rest-client'

#
# @see CTFC::Request
# @see Ctfc
#
module CTFC
  #
  # Get data from source.
  #
  class Client
    include CTFC::API

    attr_reader   :response
    attr_accessor :fiat, :coins, :prices, :source

    alias currency fiat

    def initialize(curr = :eur, opts = {})
      @fiat   = curr.to_s.upcase
      @save   = opts[:save].nil?   ? true           : opts[:save]
      @print  = opts[:print].nil?  ? true           : opts[:print]
      @coins  = opts[:coins].nil?  ? COINS          : Array(opts[:coins])
      @source = opts[:source].nil? ? :cryptocompare : opts[:source]
    end

    def get(source = @source)
      request = send_api_request(source)
      # binding.pry
      @response.merge! request
      Export.to_csv(response) if save?
      @prices = response[:prices]
    end

    #
    # Get fiat value from response hash with crypto prices
    # @example
    #   @data.price(:btc)
    #
    # @param [Symbol || String] coin **Required**. Coin name as symbol or string.
    # @return [Float]
    #
    def price(coin)
      prices[coin.to_s.upcase]
    end

    #
    # Check if crypto prices will be saved in `.csv` table
    # @return [true || false]
    #
    def save?
      @save == true
    end

    #
    # Check if crypto prices will be printed in terminal
    #
    # @return [true || false]
    #
    def print?
      @print == true
    end

    #
    # Change option to save '.csv' table with prices
    # @return [true || false]
    #
    def save=(opt)
      @save = opt.is_a?(TrueClass)
    end

    #
    # Change option to print prices in terminal
    # @return [true || false]
    #
    def print=(opt)
      @print = opt.is_a?(TrueClass)
    end

    #
    # Check if request was successful or not.
    # @return [true || false]
    #
    def success?
      return false if @response.nil?

      @response.code == 200
    end

    private

    def send_api_request(source)
      @response =
        case source
        when :cryptocompare
          Cryptocompare[fiat, coins]
        when :binance
          # Binance[fiat, coins]
          raise NoMethodError, 'Working on Binance implementation'
        else
          raise NoMethodError, 'Not implemented, yet! Feel free to contribute!'
        end
    end
  end
end
