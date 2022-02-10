# frozen_string_literal: true

require_relative 'api'

module CTFC
  class Request
    include API

    def self.[fiat = :eur, coins = [], source = :cryptocompare]
      unless fiat.is_a?(Symbol) && source.is_a?(Symbol) && coins.is_a?(Array)
        raise TypeError, 'Use symbols, and array of strings for coins'
      end
      process_source fiat, coins, source
    end

    private

    def process_source(fiat, coins, source)
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
