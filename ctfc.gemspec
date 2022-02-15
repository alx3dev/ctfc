# frozen_string_literal: true

require_relative './lib/ctfc/version'

Gem::Specification.new do |s|
  s.name        = 'ctfc'
  s.version     = CTFC::VERSION
  s.summary     = 'Cryptocurrency to Fiat values, get data and save prices.'
  s.description = <<~DESCRIPTION
    Convert any cryptocurrency to any fiat value, export data to csv table.
    Print colorized terminal output.
  DESCRIPTION

  s.license = 'MIT'
  s.authors = 'alx3dev'
  s.homepage = 'https://github.com/alx3dev/ctfc'

  s.bindir = 'bin'
  s.require_paths = 'lib'
  s.executables = 'ctfc'

  s.metadata['homepage_uri'] = 'https://github.com/alx3dev/ctfc'
  s.metadata['source_code_uri'] = 'https://github.com/alx3dev/ctfc'
  s.metadata['bug_tracker_uri'] = 'https://github.com/alx3dev/ctfc/issues'
  s.metadata['changelog_uri'] = 'https://github.com/alx3dev/ctfc/CHANGELOG.md'
  s.metadata['documentation_uri'] = "https://rubydoc.info/gems/#{s.name}/#{s.version}"
  s.metadata['license_uri'] = 'https://github.com/alx3dev/ctfc/LICENSE'
  s.metadata['rubygems_mfa_required'] = 'true'

  s.files = %w[ lib/ctfc.rb
                lib/ctfc/version.rb
                lib/ctfc/export.rb
                lib/ctfc/client.rb
                lib/ctfc/api.rb
                lib/ctfc/api/apitemplate.rb
                lib/ctfc/api/cryptocompare.rb
                LICENSE
                README.md
                ctfc.gemspec]

  s.required_ruby_version = '> 2.7', '< 3.2'

  s.add_runtime_dependency 'optimist', '~> 3.0.1'
  s.add_runtime_dependency 'rest-client', '~> 2.1.0'

  s.add_development_dependency 'bundler', '~> 2.3'
  s.add_development_dependency 'pry', '~> 0.14'
  s.add_development_dependency 'rake', '~> 13.0'
end
