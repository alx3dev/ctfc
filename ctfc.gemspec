# frozen_string_literal: true

require_relative './lib/ctfc/version'

Gem::Specification.new do |s|
  s.name        = 'ctfc'
  s.version     = CTFC::VERSION
  s.summary     = 'Crypto to Fiat currency data gathering'
  s.description = <<~DESC
    Convert any crypto to fiat currency, gather all data and/or save in `.csv` table.
  DESC

  s.license = 'MIT'
  s.authors = 'alx3dev'
  s.homepage = 'https://github.com/alx3dev/ctfc'

  s.bindir = 'bin'
  s.require_paths = ['lib']
  s.executables = ['ctfc']

  s.metadata['homepage_uri'] = 'https://github.com/alx3dev/ctfc'
  s.metadata['source_code_uri'] = 'https://github.com/alx3dev/ctfc'
  s.metadata['bug_tracker_uri'] = 'https://github.com/alx3dev/ctfc/issues'

  s.files = ['bin/ctfc', 'bin/console', 'lib/ctfc.rb', 'LICENSE', 'README.md', 'ctfc.gemspec',
             'lib/ctfc/config.rb', 'lib/ctfc/version.rb', 'lib/ctfc/base.rb']

  s.required_ruby_version = '>= 3.0.1'

  s.add_runtime_dependency 'colorize', '~> 0.8.1'
  s.add_runtime_dependency 'optimist', '~> 3.0.1'
  s.add_runtime_dependency 'rest-client', '~> 2.1.0'

  s.add_development_dependency 'bundler', '~> 2.2.9'
  s.add_development_dependency 'pry', '~> 0.14.1'
  s.add_development_dependency 'rake', '~> 13.0.3'
end
