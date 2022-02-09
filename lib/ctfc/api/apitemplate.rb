# frozen_string_literal: true

module CTFC
  module API
    class ApiTemplate
      include Steroids

      MAX_RETRY = 3
      BASE_URL = {
        cryptocompare: 'https://min-api.cryptocompare.com/data/pricemultifull?'
      }.freeze

      at_reader :response, as:{counter: 0, prices: {},
                               uri: BASE_URL[self.class.name.downcase.to_sym]}

      def initialize(fiat, coins)
        process fiat, coins
      end

      private

      def process(*)
      end
    end
  end

  ##
  # @example Allow attr_reader with default Hash options
  #
  #  attribute_reader :client, as: {username: 'alx'}
  #
  module Steroids
    def attribute_reader(*args, **opts)
      args.count.times do
        name = args.shift.to_sym
        if opts.key? :as
          define_method(name) do
            instance_variable_set "@#{name}", opts[:as]
          end
        end
      end
    end
    alias at_reader attribute_reader
  end
end
