# frozen_string_literal: true

require_relative 'version' unless defined? CTFC::VERSION
require_relative 'api/apitemplate' unless defined? CTFC::API::ApiTemplate

# automatically require new apis
CTFC::API.list.select { |source| require_relative "api/#{source}" }

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
