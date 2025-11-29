# frozen_string_literal: true

require_relative 'lib/rcharts/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.4.0'
  spec.name        = 'rcharts'
  spec.version     = RCharts::VERSION
  spec.authors     = ['Justin Malčić']
  spec.email       = ['j.malcic@me.com']
  spec.homepage    = 'TODO'
  spec.summary     = 'TODO: Summary of RCharts.'
  spec.description = 'TODO: Description of RCharts.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "TODO: Put your gem's public repo URL here."
  spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 8.1.1'
end
