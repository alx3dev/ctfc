# About

Convert any crypto to fiat currency, gather all data and/or save in `.csv` table.  
For now only prices are printed/saved, while all data remain easily accessible from variable (for developers).  
  
  
# How to install

Make sure you have ruby and git installed:

```bash
 git clone https://github.com/alx3dev/ctfc.git
 cd ctfc && bundle install
```  
  
# How to run

```bash
ruby bin/ctfc fiat_1, fiat_2, fiat_3
```

This command also accept multiple arguments:

 - `--no-save`  -  do not save `.csv.` output
 - `--no-print` -  do not print terminal output
 - `--coins`    -  coins to scrap (default: BTC, LTC, XMR, ETH, BCH, ZEC )
 - `--help`     -  help menu
  
  
# Script Examples

 1 - Run script without arguments (default options)  
 
 ```
 ruby bin/ctfc 
 
  @return:  
   print EUR rates for default coins (BTC, LTC, XMR, ETH, BCH, ZEC)
   do not save '.csv' table 
 ```     
     
     
 2 - Add fiat currencies as arguments  

```
ruby bin/ctfc eur usd rsd

 @return:  
  print EUR, USD, RSD rates for default coins 
  save data in '.csv' table with pattern: 'crypto_CURRENCY.csv'
   -> './crypto_eur.csv', './crypto_usd.csv', './crypto_rsd.csv'
```

 3 - Use `--no-save` and/or `--no-print`  
 
```
ruby bin/ctfc eur --no-print --coins btc xmr ltc
 
 @return:
  save EUR rates for BTC, XMR and LTC
  do not print output  
  
  
ruby bin/ctfc rsd --no-save --coins btc xmr

 @return:
  print RSD rates for BTC and XMR
  
```  

  
# Developer Examples

Update from Version-0.2.0

```ruby
# This two classes extend CTFC::Data, so you can use all methods, with some shortcuts

class Ctfc < CTFC::Data; end

class Crypto < Ctfc; end
```  

```ruby
# define coins to scrap
  COINS = %w[ BTC XMR LTC ETH ]

# initialize Data class  
  # DEPRECEATED - use Ctfc.new instead
  @data = CTFC::Data.new :eur, save: false, print: false, coins: COINS  
   @return CTFC::Data object with data to perform request
    => #<CTFC::Data:0x000055715a6ce898 @coins=["BTC", "LTC", "XMR", "ETH", "BCH", "ZEC"], @currency="EUR", @print=true, @save=false>
 
# execute request
  @data.get
   @return Hash with upcase string coins as keys, and float prices
    => {"BTC"=>36760.11, "XMR"=>169.55, "LTC"=>114.4, "ETH"=>2746.22}
  
# now you can use ::Data instance methods
  @data.response
   @return RestClient response to cryptocomare API
    => <RestClient::Response 200 "{\"RAW\":{\"BT...">
   
  @data.url
   @return Cryptocompare API url
    => "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC&fsyms=LTC&fsyms=XMR&fsyms=ETH&fsyms=BCH&fsyms=ZEC&tsyms=EUR"
    
  @data.table
   @return '.csv' table name
    => 'ctfc_eur.csv'
    
  @data.coins
   @return coins for scrap, also allow setter method @data.coins = [...]
    => ['BTC', 'XMR', 'LTC', 'ETH']
    
  @data.data
   @return all data returned by cryptocompare API
    => ... ... ...
    
  
  TO BE CONTINIUED ...
```    

**Class methods added in Version-0.2.0**

```ruby
# class Ctfc < CTFC::Data has been added, with class methods for RSD, EUR, USD

 Ctfc.to_rsd( print: false )
# or alias method
 Ctfc.rsd( save: false )


# Also class Crypto < Ctfc, as alias

 Crypto.to_eur coins: %w[btc xmr ltc]
```  
  
# TO-DO:
Write documentation, examples and use-cases as gem dependency
