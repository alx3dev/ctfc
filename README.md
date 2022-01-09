# About

Convert any crypto to fiat currency, gather all data and/or save in `.csv` table.

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

 - `--no-save` - do not save `.csv.` output
 - `--no-print` - do ont print terminal output
 - `--coins` - coins to scrap
 - `--help` - help menu

