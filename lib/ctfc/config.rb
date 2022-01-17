module CTFC

  ##
  # Keep default configuration data, like coins to scrap, max number
  # of retries and cryptocompare API url.
  #
  module CONFIG

    # default coins to use
    COINS = %w[ BTC LTC XMR ETH BCH ZEC ].freeze

    # max number of retries if request fail
    MAX_RETRY = 3.freeze

    # Cryptocompare API - base url for requests
    URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'.freeze

  end
end
