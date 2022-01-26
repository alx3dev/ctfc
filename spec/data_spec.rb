# frozen_string_literal: true

require_relative './spec_helper'

FIAT = :usd
CRYPTO = %w[BTC XMR ETH].freeze

RSpec.describe CTFC::Data do
  let(:crypto) { CTFC::Data.new(FIAT, coins: CRYPTO, save: nil, print: nil) }

  context 'Initialized Configuration' do
    it 'sets currency as string from given symbol' do
      expect(crypto.fiat).to eq FIAT.to_s.upcase
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
  end
end

RSpec.describe CTFC::Data do
  let(:crypto) { CTFC::Data.new(FIAT, coins: @coins, save: nil, print: nil) }

  context 'Change configuration on-the-fly' do
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
