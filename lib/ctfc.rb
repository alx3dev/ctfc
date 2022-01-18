#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ctfc'
require 'optimist'

  opts = Optimist.options do

    version "Software Version: #{CTFC::VERSION}"

    banner ""
    banner " Enter fiat currencies with/out additional arguments:"
    banner ""
    banner "  ruby bin/ctfc eur"
    banner "  ruby bin/ctfc eur usd --no-save --coins btc xmr ltc"
    banner ""

    opt :coins,    "Set crypto coins",   default: CTFC::CONFIG::COINS
    opt :no_save,  "Do not save '.csv' output"
    opt :no_print, "Do not print terminal output"
  end


  save  = opts[:no_save]  ? false : true
  print = opts[:no_print] ? false : true

  if ARGV.empty?

    Crypto.to :eur, save: false, print: true

  else

    ARGV.each do |fiat|

      Ctfc.to(fiat,
              save: save,
              print: print,
              coins: opts.coins) unless opts.include? fiat.downcase
    end
  end
