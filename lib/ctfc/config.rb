module CTFC

  module CONFIG

    # set default coins
    COINS = %w[ BTC LTC XMR ETH BCH ZEC ].freeze

    # max number of retries
    MAX_RETRY = 3

    # api base-url
    URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'.freeze

  end
end
