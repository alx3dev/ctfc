# frozen_string_literal: true

require_relative 'ctfc/client'
require_relative 'ctfc/version'

# Ctfc is shortcut for CTFC::Client.
# @see CTFC::Client
class Ctfc < CTFC::Client
end

# Shortcut to initialize new client,
# and get prices hash.
#
# @example Get EUR prices for coins:
#   coins = %w[BTC XMR LTC ETH]
#   Crypto.to :eur, coins, :cryptocompare, save: true
#
class Crypto
  # @return [Hash]
  # @see CTFC::Client
  def self.to(*args)
    CTFC::Client.new(*args).get
  end
end
