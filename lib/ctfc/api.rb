# frozen_string_literal: true

# Benchmark say it's faster to use **unless defined?** if we require file
# on multiple locations

require_relative 'api/apitemplate' unless defined? CTFC::API::ApiTemplate
require_relative 'helpers/list' unless defined? List

# automatically require new apis
List.sources.select { |source| require_relative "api/#{source}" }

module CTFC
  #
  # Keep sources to extract data. Each source has to be a class,
  # named as API domain, extending ApiTemplate. This will automatically
  # make it available in Client, but also added to .gemspec.
  #
  # @see CTFC::API::ApiTemplate
  # @see CTFC::API::Cryptocompare
  #
  # @example Add a new source to extract data:
  #  # make file new_source.rb
  #  class NewSource < ApiTemplate
  #
  #    private
  #
  #    def process
  #      # check response hash for persistence of fiat and coins
  #      super
  #      # write method to scrap data from NewSource
  #    end
  #  end
  #
  module API
  end
end
