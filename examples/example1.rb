#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ctfc'

# define coins to scrap
Crypto::COINS = %w[BTC XMR LTC ETH].freeze

# define class for USD [save only]
class USD
  def initialize
    Crypto.to :usd, save: true, print: false
  end
end

# define class for EUR [print and save]
class EUR
  def initialize
    Crypto.to :eur, save: true, print: true
  end
end

##
# Get crypto prices every 5 minutes.
# Print and save EUR rates, print-only USD rates.
#
loop do
  USD.new
  EUR.new
  sleep 300
end
