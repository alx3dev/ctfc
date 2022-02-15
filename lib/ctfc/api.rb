# frozen_string_literal: true

require_relative 'api/apitemplate'

require 'rest-client'
require 'json'

module CTFC
  #
  # Keep sources to scrap data. Each source should be class,
  # named as api domain, extending ApiTemplate.
  #
  # @see CTFC::API::ApiTemplate
  # @see CTFC::API::Cryptocompare
  #
  # @example Add new source
  #  class NewSource < ApiTemplate
  #
  #    private
  #
  #    def process
  #      super
  #      # write method to scrap data from NewSource
  #    end
  #  end
  #
  module API
    class << self
      #
      # Get list of sources from files in api dir.
      # @return [Array] Array of symbols
      #
      def list
        @list ||= list_files_in_api_dir
      end

      private

      def list_files_in_api_dir
        sources = []
        skip = %w[. .. apitemplate.rb]
        path = File.expand_path(__FILE__).gsub!('.rb', '')
        Dir.entries(path).select do |source|
          next if skip.include? source

          sources << source.gsub('.rb', '').to_sym
        end
        sources
      end
    end
  end
end
#
# automatically require new apis
# to-do: change #to_s to #name for ruby3
#
CTFC::API.list.select { |source| require_relative "api/#{source}" }
