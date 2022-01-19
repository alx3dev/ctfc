#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ctfc'

##
# Use default coins, get prices in RSD every 5 minutes.
# Print terminal output, append data to `.csv` table.
#
@client = Ctfc.new :rsd
loop do
  @client.get
  sleep 300
end

##
# Get prices for EUR, USD and RSD with different configuration
#
@eur = Ctfc.new :eur, coins: %w[BTC XMR]
@usd = Ctfc.new :usd, print: false, coins: %w[BTC XMR]
@rsd = Ctfc.new :rsd, save: false, %w[LTC ETH]

loop do
  @eur.get
  @usd.get
  @rsd.get
  sleep 300
end
