# frozen_string_literal: true

require_relative 'config'
require_relative 'version'

require 'json'
require 'csv'
require 'kolorit'
require 'rest-client'

##
# @see CTFC::Request
# @see Ctfc
#
module CTFC
  ##
  # Data class keep all the logic to send request, receive response,
  # and everything between. Class Ctfc extend CTFC::Client, for easier work.
  #
  # @note Instead of using CTFC::Client.new, you can also call Ctfc.new
  #
  class Client
    attr_reader   :response
    attr_accessor :fiat, :coins, :prices, :source

    alias currency fiat

    ##
    # @example Initialization example
    #   @data = CTFC::Client.new :eur, save: true
    #
    # @param [Symbol] currency **Optional**. Define fiat currency.
    # @param [Hash] opts **Optional**. Additional options hash.
    #
    # @option opts [Boolean] print **Optional**. Print terminal output.
    # @option opts [Boolean] save **Optional**. Save `.csv` output.
    # @option opts [Array] coins **Optional**. Define coins to scrap.
    #
    # @return [Client] Client instance
    #
    def initialize(curr = :eur, opts = {})
      @fiat   = curr.name.upcase
      @save   = opts[:save].nil?   ? true           : opts[:save]
      @print  = opts[:print].nil?  ? true           : opts[:print]
      @coins  = opts[:coins].nil?  ? COINS          : Array(opts[:coins])
      @source = opts[:source].nil? ? :cryptocompare : opts[:source]
    end

    def get
      call_api_request
      prices = response[:prices]
    end

    ##
    # Get fiat value from response hash with crypto prices
    #
    # @example
    #
    #   @data.price(:btc)
    #
    # @param [Symbol || String] coin **Required**. Coin name as symbol or string.
    # @return [Float]
    #
    def price(coin)
      prices[coin.to_s.upcase]
    end

    ##
    # Check if crypto prices will be saved in `.csv` table
    #
    # @return [true || false]
    #
    def save?
      @save == true
    end

    ##
    # Check if crypto prices will be printed in terminal
    #
    # @return [true || false]
    #
    def print?
      @print == true
    end

    ##
    # Change option to save '.csv' table with prices
    #
    # @return [true || false]
    #
    def save=(opt)
      @save = opt.is_a?(TrueClass)
    end

    ##
    # Change option to print prices in terminal
    #
    # @return [true || false]
    #
    def print=(opt)
      @print = opt.is_a?(TrueClass)
    end

    ##
    # Check if request was successful or not.
    #
    # @return [true || false]
    #
    def success?
      return false if @response.nil?

      @response.code == 200
    end

    private

    def call_api_request
      @response =
        case @source
        when :cryptocompare
          Cryptocompare[@fiat, @coins]
        when :binance
          # Binance[fiat, coins]
          raise NoMethodError, 'Working on Binance implementation'
        else
          raise NoMethodError, 'Not implemented, yet! Feel free to contribute!'
        end
    end

  end
end
