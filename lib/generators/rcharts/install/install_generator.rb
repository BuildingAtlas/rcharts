# frozen_string_literal: true

module RCharts
  class InstallGenerator < Rails::Generators::Base # :nodoc:
    namespace :'rcharts:install'

    source_root File.expand_path('templates', __dir__)

    def create_rcharts_files
      template 'rcharts.css', 'app/assets/stylesheets/rcharts.css'
    end
  end
end
