# frozen_string_literal: true

module CTFC
  # gem version
  VERSION = '1.0.0-dev'

  module API
    class << self
      #
      # List sources as Array of Symbols.
      # @return [Array] Array of sources as :symbols
      #
      def list
        @list ||= list_files_in_api_dir
      end

      # Get list of sources from files in api dir (for .gemspec).
      #
      # @return [Array] Array of sources as strings.
      #
      def list_of_sources
        @list_of_sources ||= list_files_in_api_dir(gemspec: true)
      end

      private

      def list_files_in_api_dir(gemspec: false)
        sources = []
        skip = %w[. .. apitemplate.rb]
        path = File.expand_path(__FILE__).gsub!('version.rb', 'api')
        Dir.entries(path).select do |source|
          next if skip.include? source

          source = source.gsub('.rb', '').to_sym unless gemspec == true
          sources << source
        end
        sources
      end
    end
  end
end
