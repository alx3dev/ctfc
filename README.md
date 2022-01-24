# About
Convert any crypto to fiat currency, gather all data and/or save in `.csv` table.  
For now only prices are printed/saved, while all data remain easily accessible from variable (for developers).  
  
  
# How to install
Make sure you have ruby and git installed  

Install from source:
```bash
 git clone https://github.com/alx3dev/ctfc.git
 cd ctfc && bundle install
```  

Install from rubygems:

```bash
gem install ctfc
```
# How to run
  - **Read documentation on:** https://rubydoc.info/gems/ctfc/CTFC/Data  

```bash
ruby bin/ctfc fiat_1 fiat_2 fiat_3
```

This command also accept multiple arguments:

 - `--no-save`  - do not save `.csv.` output
 - `--no-print` - do not print terminal output
 - `--coins`    - coins to scrap (default: BTC, LTC, XMR, ETH, BCH, ZEC )
 - `--loop`     - repeat script N times (default 1)
 - `--wait`     - wait N seconds between loops (default 0)
 - `--help`     - help menu
  
  
# Script Examples
 1 - Run script without arguments (default options)  
 
```ruby
 ruby bin/ctfc 
 
 => return:  
      print EUR rates for default coins (BTC, LTC, XMR, ETH, BCH, ZEC)
      do not save '.csv' table 
```  
     
     
 2 - Add fiat currencies as arguments  

```ruby
ruby bin/ctfc eur usd rsd

 => return:  
      print EUR, USD, RSD rates for default coins 
      save data in '.csv' table with pattern: 'crypto_#{CURRENCY}.csv'
      -> './crypto_eur.csv', './crypto_usd.csv', './crypto_rsd.csv'
```

 3 - Use `--no-save`, `--no-print`, `--loop`, `--wait`
 
```ruby
ruby bin/ctfc eur --no-print --coins btc xmr ltc
 
 => return:
      save EUR rates for BTC, XMR and LTC
      do not print output  
  
  
ruby bin/ctfc rsd --no-save --coins btc xmr

 => return:
      print RSD rates for BTC and XMR


# added in version 0.4.0
ruby bin/ctfc rsd --no-print --loop 1440 --wait 60

 => return:
      save RSD rates without print, run each minute for 24 hours
```  

  
# Developer Examples
```ruby
  # define coins to scrap
  COINS = %w[ BTC XMR LTC ETH ]

  # initialize Data class  
  @data = Ctfc.new :eur, save: false, print: false, coins: COINS
    => return Ctfc object to work with
    -> #<Ctfc:0x000055b5c8b61a38 @coins=["BTC", "LTC", "XMR", "ETH", "BCH", "ZEC"], @fiat="EUR", @print=true, @save=true>
 
  # execute request
  @data.get
    => return Hash with upcase string coins as keys, and float prices
    -> {"BTC"=>36760.11, "XMR"=>169.55, "LTC"=>114.4, "ETH"=>2746.22}
  
  # now you can use ::Data instance methods
  @data.response
    => return RestClient response to cryptocomare API
    -> <RestClient::Response 200 "{\"RAW\":{\"BT...">
  
  # check request url 
  @data.url
    => return Cryptocompare API url
    -> "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC&fsyms=LTC&fsyms=XMR&fsyms=ETH&fsyms=BCH&fsyms=ZEC&tsyms=EUR"
  
  # name of csv table (saved in working directory)  
  @data.table
    => return '.csv' table name
    -> 'ctfc_eur.csv'

  # array of coins to work with
  @data.coins
    => return coins for scrap, also allow setter method @data.coins = [...]
    -> ['BTC', 'XMR', 'LTC', 'ETH']

  # get all data about all coins (json api response)
  @data.data
    => return all data returned by cryptocompare API
    -> {"RAW"=>
      {"BTC"=>
        {"EUR"=>
          {"TYPE"=>"5",
           "MARKET"=>"CCCAGG",
           "FROMSYMBOL"=>"BTC",
           "TOSYMBOL"=>"EUR",
           "FLAGS"=>"2049",
           "PRICE"=>33851.17,
           "LASTUPDATE"=>1642773847,
           "MEDIAN"=>33853.8,
           "LASTVOLUME"=>0.1,
           "LASTVOLUMETO"=>3384.3676,
           "LASTTRADEID"=>"2024043",
           ... ... ... ... ... ... ...
    
  
  TO BE CONTINIUED ...
```    

**Class methods as shortcuts:**

```ruby
# get default coins in EUR, save output without printing
  prices = Ctfc.to :eur, print: false

# get default coins in RSD, print output, don't save
  Ctfc.to :rsd, save: false
 
# For those who don't like name `Ctfc`, you can use `Crypto` too:
  prices = Crypto.to :eur, coins: %w[BTC XMR]
```  

# Tests
To run tests use `./check-syntax.sh`.  
This command will run rubocop for code inspection, but with some errors hidden by `.rubocop_todo.yml`. Using check-syntax script, all test should pass.


# Contribution
Any contribution is highly appreciated, as long as you follow Code of Conduct.

 - Fork repository
 - Make your changes
 - Write tests
 - Submit pull request  

# License
Don't be a dick - it's MIT.

# To-Do:
See **Projects**
