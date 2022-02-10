# frozen_string_literal: true

require 'rest-client'
require 'json'

# automatically require new apis
CTFC::API.list.select { |x| require_relative x }

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
          sources << source.gsub('.rb', '').to_sym unless skip.include? source
        end
        @list = sources
      end
    end
  end
end
