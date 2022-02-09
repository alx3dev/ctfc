# frozen_string_literal: true

require 'rest-client'
require 'json'

require_relative 'api/cryptocompare'

module CTFC
  module API
    class << self
      ##
      # List available sources by *:symbolizing* filenames without
      # **.rb** extension in **API** directory.
      #
      # @return [Array] Array of symbols as available sources
      #
      def list
        sources, skip = [], %w[. ..]
        # use select instead of map to avoid nil in array
        Dir.entries("#{File.expand_path(__FILE__)}/api").select do |source|
          sources << source.gsub('.rb', '').to_sym unless skip.include? source
        end
        sources
      end
    end
  end
end
