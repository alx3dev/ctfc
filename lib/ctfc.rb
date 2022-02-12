# frozen_string_literal: true

require_relative 'ctfc/client'

##
# For easier job use Ctfc, instead of typing CTFC::Data.
# You can define default coins with Ctfc::COINS=
#
# @note For instance methods look at CTFC::Data.
#
class Ctfc < CTFC::Client
  ##
  # @todo Allow Ctfc to use proxy and/or tor
  #
  def initialize(currency = :eur, opts = {})
    super(currency, opts)
  end

  ##
  # @example Get EUR data for BTC, XMR, LTC, ETH, print but don't save output
  #
  #   Ctfc.to :eur, save: false, coins: %w[BTC XMR LTC ETH]
  #
  # @param [Symbol] currency **Required**. Define fiat currency.
  # @param [Hash] opts **Optional**. Additional options hash.
  #
  # @option opts [Boolean] print **Optional**. Print terminal output.
  # @option opts [Boolean] save **Optional**. Save `.csv` output.
  # @option opts [Array] coins **Optional**. Define coins to scrap.
  #
  # @return [Hash] CTFC::Data#prices || CTFC::Data#response
  #
  def self.to(currency, opts = {})
    new(currency.to_sym, opts).get
  end
end

##
# Same as Ctfc
# @see Ctfc
# @see CTFC::Data
#
class Crypto < Ctfc
  def initialize(currency = :eur, opts = {})
    opts[:coins] ||= COINS
    super(currency, opts)
  end
end
