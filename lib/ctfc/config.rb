# frozen_string_literal: true

module CTFC
  ##
  # Keep default configuration data, like coins to scrap, max number
  # of retries and cryptocompare API url.
  #
  module CONFIG
    # default coins to use
    COINS = %w[BTC LTC XMR ETH BCH ZEC].freeze

    # max number of retries if request fail
    MAX_RETRY = 3

    # Cryptocompare API - base url for requests
    URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'
  end
end

##
# Remove colorize to allow MIT license
# Credits for time-saving:
# https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal/11482430#11482430
#
class String
  ##
  # colorize string based on color_code
  #
  def colorize(color_code)
    # check if we change color or type
    type = case color_code
           when 1 then 22 # bold
           when 3 then 23 # italic
           when 4 then 24 # underline
           when 5 then 25 # blink
           when 7 then 27 # reverse_color
           else 0
           end
    "\e[#{color_code}m#{self}\e[#{type}m"
  end

  def yellow() = colorize(33)

  def green() = colorize(32)

  def cyan() = colorize(36)

  def bold() = colorize(1)
end
