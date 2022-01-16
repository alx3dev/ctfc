require_relative 'config'
require_relative 'version'

require 'json'
require 'csv'
require 'colorize'
require 'rest-client'

module CTFC

  ##
  # Data class keep all the logic to send request, receive response,
  #   and everything between.
  class Data

    include CTFC::CONFIG

    attr_reader   :response, :data, :url, :table, :count, :prices
    attr_accessor :fiat, :coins

    alias :currency :fiat


    def self.get!( currency = :eur, opts = {} )
      new(currency, opts).get
    end

    ##
    # @example Initialization example
    #
    #   @data = CTFC::Data.new :eur, save: true
    #
    # @param [Symbol] currency **Optional**. Define fiat currency.
    # @param [Hash] opts **Optional**. Additional options hash.
    #
    # @option [Boolean] print **Optional**. Print terminal output.
    # @option [Boolean] save **Optional**. Save `.csv` output.
    # @option [Array] coins **Optional**. Define coins to scrap.
    #
    # @return [Hash] Data#prices || Data#response
    #
    def initialize( currency = :eur, opts = {} )
      @fiat  = currency.to_s.upcase
      @save  = opts[:save].nil?  ? true : opts[:save]
      @print = opts[:print].nil? ? true : opts[:print]
      @coins = opts[:coins].nil? ? COINS : Array(opts[:coins])
    end

    ##
    # @example Get fiat prices for previous config
    #
    #   @data.get
    #
    # @example Get prices and change previous config "on-the-fly"
    #
    #   @data.get :usd, save: false, coins: %w[BTC XMR ETH]
    #
    def get( c = nil, opts = {} )
      @fiat  = c.to_s.upcase unless c.nil?
      @coins = opts[:coins]  unless opts[:coins].nil?
      @save  = opts[:save]   unless opts[:save].nil?
      @print = opts[:print]  unless opts[:print].nil?
      @count, @table = 0, "ctfc_#{@fiat}.csv".downcase
      do_rest_request
    end

    ##
    # Get fiat value for crypto
    #
    # @example
    #
    #   @data.price(:btc)
    #
    def price( coin )
      @prices[coin.to_s.upcase]
    end

    ##
    # Check if crypto prices will be saved in `.csv` table
    #
    def save?
      @save == true
    end

    ##
    # Check if crypto prices will be printed in terminal
    #
    def print?
      @print == true
    end

    ##
    # @param [Boolean] save **Required**. Save csv output after request.
    #
    # @return [true || false]
    #
    def save=(opt)
      @save = opt.is_a?(TrueClass) ? true : false
    end

    ##
    # @param [Boolean] print **Required**. Save csv output after request.
    #
    # @return [true || false]
    #
    def print=(opt)
      @print = opt.is_a?(TrueClass) ? true : false
    end


    private


    def do_rest_request
      @prices, @data_array, coin_uri = {}, [], ''

      @coins.collect { |coin| coin_uri << "fsyms=#{coin}&" }
      @url = URL + "#{coin_uri}tsyms=#{@fiat}"

      @response = RestClient.get @url
      @data = JSON.parse @response

      @data_array << Time.now.to_s

      @coins.each do |coin|
        @data_array << value = @data["RAW"][coin.to_s.upcase][@fiat.to_s.upcase]["PRICE"].round(2)
        @prices[coin] = value
      end

      print_fiat_values if print?
      save_csv_data if save?

      return @prices

     rescue
      @count += 1

      unless @count >= MAX_RETRY
        do_rest_request 
      else
        puts @response.to_s.split(',')
        exit(1)
      end
    end  # end of do_rest_request


    def print_fiat_values
      30.times { print '='.green }; puts

      puts "[".green + @fiat.to_s.upcase.yellow.bold + "]".green + " conversion rate"
      30.times { print '='.green }; puts

      @prices.each do |name, value|
        print "[".yellow.bold + "#{name}".green.bold + "]".yellow.bold
        puts ": #{value}".bold
      end
    end
  

    def save_csv_data
      create_csv_headers unless File.exist?(@table)
      CSV.open(@table, 'ab') { |column| column << @data_array }
    end


    def create_csv_headers
      header_array = ['TIME']
      @coins.each { |coin| header_array << coin }
      CSV.open(@table, "w" ) { |header| header << header_array }
    end

  end
end
