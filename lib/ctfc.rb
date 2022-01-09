require_relative 'ctfc/base'

require 'json'
require 'csv'
require 'colorize'
require 'rest-client'

module CTFC

  class Data

    def self.get!( currency = :eur, opts = {} )
      self.new(currency, opts).get
    end

  end
end
