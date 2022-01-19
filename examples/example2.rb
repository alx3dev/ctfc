#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ctfc'

##
# @note You can do this with `bin/ruby ctfc usd eur rsd`, this is just example.
#
# Make base class to extend it with class named as currency code.
# Set configuration to save '.csv' table without terminal output,
# and scrap data for Bitcoin, Monero and Ethereum.
#
class Fiat
  def initialize
    currency = instance_of?(Fiat) ? 'EUR' : self.class.name

    Crypto.to(currency,
              save: true,
              print: false,
              coins: %w[BTC XMR ETH])
  end
end

# name class as currency code
class USD < Fiat; end
class EUR < Fiat; end
class RSD < Fiat; end
class GBP < Fiat; end

# check if arguments contain any of defined currencies
ARGV.select do |arg|
  case arg
  when 'usd', 'USD' then USD.new
  when 'rsd', 'RSD' then RSD.new
  when 'eur', 'EUR' then EUR.new
  when 'gbp', 'GBP' then GBP.new
  else puts "#{arg} is not supported at this time."
  end
end
