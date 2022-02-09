# frozen_string_literal: true

require 'rest-client'
require 'json'

require_relative 'api/cryptocompare'

module CTFC
  module API
    def self.list
      sources = []
      Dir.entries("#{File.expand_path(__FILE__)}"/api).select do |file|
        sources << file.gsub('.rb', '').to_sym unless %w[. ..].include? file
      end
      sources
    end
  end
end
