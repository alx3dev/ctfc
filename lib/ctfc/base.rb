require_relative 'config'
require_relative 'version'

module CTFC
  
  class Data

    include CTFC::CONFIG

    attr_reader   :response, :data, :url, :table, :count, :prices
    attr_accessor :fiat, :coins


    def initialize( currency = :eur, opts = {} )
      @save  = opts[:save].nil?  ? true : opts[:save]
      @print = opts[:print].nil? ? true : opts[:print]
      @coins = opts[:coins].nil? ? COINS : Array(opts[:coins])
      @currency = currency.to_s.upcase
    end


    def get( currency = nil, opts = {} )
      @currency = currency if currency

      @coins = opts[:coins] unless opts[:coins].nil?
      @save  = opts[:save]  unless opts[:save].nil?
      @print = opts[:print] unless opts[:print].nil?

      @table = 'crypto_' + @currency.to_s.downcase + '_rates.csv'
      @count = 0

      do_rest_request
    end


    def price( coin )
      @prices[coin.to_s.upcase]
    end


    def save?
      @save == true
    end


    def print?
      @print == true
    end


    def save=(opt)
      @save = opt
    end


    def print=(opt)
      @print = opt
    end


    private


    def do_rest_request
      @prices, @data_array, coin_uri = {}, [], ''

      @coins.collect { |coin| coin_uri << "fsyms=#{coin}&" }
      @url = URL + "#{coin_uri}tsyms=#{@currency}"

      @response = RestClient.get @url
      @data = JSON.parse @response

      @data_array << Time.now.to_s

      @coins.each do |coin|
        @data_array << value = @data["RAW"][coin.to_s.upcase][@currency.to_s.upcase]["PRICE"].round(2)
        @prices[coin] = value
      end

      print_fiat_values if print?
      save_csv_data if save?

     rescue

      @count += 1
      if @count >= MAX_RETRY
        puts @response.to_s.split(',')
        exit 1
      else
        do_rest_request
      end
    end


    def print_fiat_values
      30.times { print '='.green }; puts

      puts "[".green + @currency.to_s.upcase.yellow.bold + "]".green + " conversion rate"
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
