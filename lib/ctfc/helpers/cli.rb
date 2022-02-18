# frozen_string_literal: true

require 'kolorit'

# Helper class to print colorized output in terminal.
#
class Cli
  class << self
    #
    # @example Print colorized output
    #  Cli.print_output :eur, prices = { 'BTC' => 36985.82, 'XMR' => 151.83 }
    #
    # @param [Symbol] fiat **Required**. Fiat currency symbol.
    # @param [Hash] prices **Required**. Prices hash.
    #
    def print_output(fiat, prices)
      puts line
      puts colorize(:bold) { "[#{fiat.upcase.yellow}#{']'.bold} conversion rate" }
      puts line
      prices.each { |coin, value| print_prices coin, value }
    end

    # @example Set terminal colors for price hash
    #  Cli.colors color1: :yellow, color2: :green
    #
    def colors(clrs = {})
      configure if @config.nil?
      @config[:color1]     = clrs[:color1]     if clrs[:color1]
      @config[:color2]     = clrs[:color2]     if clrs[:color2]
      @config[:line_color] = clrs[:line_color] if clrs[:line_color]
      config
    end

    private

    def print_prices(coin, value)
      color1 = config[:color1]
      color2 = config[:color2]

      coin     = kolorize coin.bold, color1
      value    = kolorize value, :bold
      br_open  = kolorize '['.bold, color2
      br_close = kolorize ']'.bold, color2

      puts colorize(:bold) { "#{br_open}#{coin}#{br_close} => #{value}" }
    end

    def config
      @config ||= { color1: :yellow, color2: :cyan, line_color: :cyan }
    end
    alias configure config

    # helper to print line
    def line
      kolorize ('=' * 30).bold, config[:line_color]
    end
  end
end
