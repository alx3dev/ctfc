# frozen_string_literal: true

require_relative './spec_helper'

RSpec.describe CTFC do
  context CTFC::CONFIG do
    it 'has crypto coins defined before initialisation' do
      expect(CTFC::CONFIG::COINS).not_to be nil
    end

    it 'has api url defined before initialisation' do
      expect(CTFC::CONFIG::URL).not_to be nil
    end

    it 'has request max retries defined before initialisation' do
      expect(CTFC::CONFIG::MAX_RETRY).not_to be nil
    end
  end

  context CTFC::Data do
    let(:currency)  { :usd }
    let(:coins)     { %w[BTC XMR ETH] }
    let(:crypto)    { CTFC::Data.new(currency, coins: coins, save: nil, print: nil) }

    it 'sets currency as string from given symbol' do
      expect(crypto.fiat).to eq currency.to_s.upcase
      expect(crypto.fiat.class).to be String
    end

    it 'sets passed coins with precedence over configured' do
      expect(crypto.coins).not_to be nil
      expect(crypto.coins.class).to be Array
      expect(crypto.coins).not_to eq CTFC::Data::COINS
    end

    it 'save csv table unless otherwise defined' do
      expect(crypto.save?).not_to be nil
      expect(crypto.save?).to be true
    end

    it 'print terminal output unless otherwise defined' do
      expect(crypto.print?).not_to be nil
      expect(crypto.print?).to be true
    end

    it 'sets options passed to #get with precedence over initialized ones' do
      initialized_currency = crypto.fiat
      # execute request
      crypto.get(:eur, print: false, save: false)
      # test results
      expect(crypto.fiat).not_to eq initialized_currency
      expect(crypto.fiat.class).to be String
      expect(crypto.fiat).to eq 'EUR'
      expect(crypto.save?).to be false
      expect(crypto.print?).to be false
    end

    it 'allow setter method for option save' do
      expect(crypto.save?).to be true
      crypto.save = false
      expect(crypto.save?).to be false
    end

    it 'allow setter method for option print' do
      expect(crypto.print?).to be true
      crypto.print = false
      expect(crypto.print?).to be false
    end
  end
end
