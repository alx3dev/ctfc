require_relative 'ctfc/base'

class Ctfc < CTFC::Data

  ##
  # @todo Allow Ctfc to use proxy and/or tor
  #
  class << self

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
    def to( currency, opts = {} )
      new(currency.to_sym, opts).get
    end
  end
end

class Crypto < Ctfc; end
