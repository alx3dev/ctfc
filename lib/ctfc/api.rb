# frozen_string_literal: true

require 'rest-client'
require 'json'

require_relative 'api/apitemplate'

# automatically require new apis
# to-do: change #to_s to #name for ruby3
CTFC::API.list.select { |api| require_relative api.to_s }

module CTFC
  module API
    class << self

      def list
        @list || get_sources_from_files_in_api_dir
      end

      private

      def get_sources_from_files_in_api_dir
        sources, skip = [], %w[. .. apitemplate.rb]
        Dir.entries("#{File.expand_path(__FILE__)}/api").select do |source|
          next if skip.include? source
          sources << source.gsub('.rb', '').to_sym
        end
        @list = sources
      end
    end
  end
end
