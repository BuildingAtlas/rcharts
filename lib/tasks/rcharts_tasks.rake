# frozen_string_literal: true

desc 'Copy over the stylesheet'
task 'rcharts:install' => :environment do
  Rails::Command.invoke :generate, ['rcharts:install']
end
