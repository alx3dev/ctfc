# frozen_string_literal: true

require_relative 'config'
require_relative 'version'

require 'json'
require 'csv'
require 'kolorit'
require 'rest-client'

##
# @see CTFC::Request
# @see CTFC::API
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
    attr_reader   :response, :data, :url, :table, :prices
    attr_accessor :fiat, :coins

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

    ##
    # @example Get fiat prices for initialized config
    #
    #   @data.get
    #
    # @example Get prices and change initialized config "on-the-fly"
    #
    #   @data.get :usd, save: false, coins: %w[BTC XMR ETH]
    #
    # @param [Symbol || String] currency **Optional**. Change fiat currency and execute request.
    # @param [Hash] opts **Optional**. Options hash to change config 'on-the-fly' - see #initialize.
    #
    # @return [Hash || false] Hash of coins and fiat values, or false if all requests fail
    #
    def get(curr = nil, opts = {})
      @fiat   = curr.to_s.upcase unless curr.nil?
      @coins  = opts[:coins]     unless opts[:coins].nil?
      @save   = opts[:save]      unless opts[:save].nil?
      @print  = opts[:print]     unless opts[:print].nil?
      @source = opts[:source]    unless opts[:source].nil?
      request = Request.new @fiat, @coins, @source
      @response = request.response
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
      @prices[coin.to_s.upcase]
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

    def print_fiat_values
      return unless print?

      30.times { print '='.cyan }
      puts ''
      puts "#{'['.cyan.bold}#{@fiat.to_s.upcase.yellow.bold}#{']'.cyan.bold} conversion rate"
      30.times { print '='.cyan }
      puts ''
      @prices.each do |name, value|
        print '['.yellow.bold + name.to_s.cyan.bold + ']'.yellow.bold
        puts ": #{value}".bold
      end
    end

    def save_csv_data
      return unless save?

      create_csv_headers unless File.exist?(@table)
      CSV.open(@table, 'ab') { |column| column << @data_array }
    end

    def create_csv_headers
      header_array = ['TIME']
      @coins.each { |coin| header_array << coin }
      CSV.open(@table, 'w') { |header| header << header_array }
    end
  end
end
