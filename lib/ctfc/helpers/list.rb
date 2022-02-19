# frozen_string_literal: true

# Get list of sources. One method for :symbolized list,
# and one for complete filenames - to include in gemspec.
#
class List
  class << self
    # List sources as Array of Symbols.
    # @return [Array] Array of sources as :symbols
    #
    def sources
      @sources ||= list_files_in_api_dir
    end

    # Get list of sources from files in api dir (for .gemspec).
    # @return [Array] Array of sources as strings.
    #
    def source_files
      @source_files ||= list_files_in_api_dir(gemspec: true)
    end

    private

    def list_files_in_api_dir(gemspec: false)
      sources = []
      skip = %w[. .. apitemplate.rb]
      path = File.expand_path(__FILE__).gsub!('helpers/list.rb', 'api')
      Dir.entries(path).select do |source|
        next if skip.include? source

        source = source.gsub('.rb', '').to_sym unless gemspec == true
        sources << source
      end
      sources
    end
  end
end
