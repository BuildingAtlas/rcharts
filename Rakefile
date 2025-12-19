# frozen_string_literal: true

require 'bundler/setup'

APP_RAKEFILE = File.expand_path('test/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

require 'bundler/gem_tasks'

require 'sdoc'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_files.include('README.md', 'app/**/*.rb', 'lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--format=sdoc'
  rdoc.options << '--github'
  rdoc.options << '--title=RCharts'
  rdoc.options << '--main=README.md'
  rdoc.template = 'rails'
end
