# frozen_string_literal: true

module CTFC
  module API
    # Template for other sources. Every file in api dir should extend this class.
    # Automatically call method #process to send api request after initialization.
    # This mean every source should include #process method, that will be executed
    # after calling **super** in initialize.
    #
    # @see CTFC::API::Cryptocompare
    #
    class ApiTemplate
      attr_reader :response

      # max number of requests to send
      MAX_RETRY = 3

      # Construct response hash from given arguments, and start counting requests.
      #
      # @param [Symbol] fiat **Required**. Fiat currency to convert coin price.
      # @param [Array] coins **Required**. Array of coins to scrap data for.
      # @param [Symbol] source **Required**. Source to tell us which api to call.
      #
      # @return [Object] ApiTemplate instance.
      #
      def initialize(fiat, coins, source)
        @response = { fiat: fiat,
                      coins: coins,
                      success: false }
        @counter  = 0
        process
      end

      private

      # @todo api key support
      # @todo proxy support
      def process
        return false unless response[:fiat] && response[:coins]
      end

      def success!(set: true)
        @counter = 0 if set == true
        @response[:success] = set
      end
    end
  end
end
