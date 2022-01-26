# frozen_string_literal: true

require_relative './spec_helper'

RSpec.describe CTFC::CONFIG do
  context 'Configuration Constants' do
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
end
