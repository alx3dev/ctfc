# frozen_string_literal: true

require_relative 'api'

module CTFC
  class Request
    attr_reader :response

    def initialize(fiat: :eur, coins: [], source: :cryptocompare)
      unless fiat.is_a?(Symbol) && source.is_a?(Symbol) && coins.is_a?(Array)
        raise TypeError, 'Use symbols, and array of strings for coins'
      end
      @response = { fiat: fiat, coins: coins, source: source, prices: {} }
      process_source source
    end

    def process_source(source = response[:source])
      case source
      when :cryptocompare
        Cryptocompare.get response[:fiat], response[:coins]
      when :binance
        raise NoMethodError, 'Working on Binance implementation'
      else
        raise NoMethodError, 'Not implemented, yet! Feel free to contribute!'
      end
    end

    private


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

