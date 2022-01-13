require_relative 'ctfc/base'

class Ctfc < CTFC::Data

  class << self

    def to_rsd( opts = {} )
      new(:rsd, opts).get
    end

    alias :rsd :to_rsd


    def to_eur( opts = {} )
      new(:eur, opts).get
    end

    alias :eur :to_eur


    def to_usd( opts = {} )
      new(:usd, opts).get 
    end

    alias :usd :to_usd

  end
end


class Crypto < Ctfc; end
