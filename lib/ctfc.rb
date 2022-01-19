# frozen_string_literal: true

require_relative 'ctfc/base'

##
# For easier job use Ctfc, instead of typing CTFC::Data.
# You can define default coins with Ctfc::COINS=
#
class Ctfc < CTFC::Data
  ##
  # @todo Allow Ctfc to use proxy and/or tor
  #
  def initialize(currency = :eur, opts = {})
    opts[:coins] ||= COINS
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
