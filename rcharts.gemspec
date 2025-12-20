# frozen_string_literal: true

require_relative 'lib/rcharts/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.4.0'
  spec.name = 'rcharts'
  spec.version = RCharts::VERSION
  spec.authors = ['Justin Malčić']
  spec.email = ['j.malcic@me.com']
  spec.homepage = 'https://buildingatlas.github.io/rcharts/'
  spec.summary = 'Responsive SVG charting for Action View.'
  spec.description = 'Helpers to generate different kinds of SVG charts from arbitrary data.'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/BuildingAtlas/rcharts'
  spec.metadata['changelog_uri'] = 'https://github.com/BuildingAtlas/rcharts/releases'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 8.1.1'
end
