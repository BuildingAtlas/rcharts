# frozen_string_literal: true

module RCharts
  class Engine < ::Rails::Engine # :nodoc:
    isolate_namespace RCharts

    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'RCharts'
    end

    config.rcharts = ActiveSupport::OrderedOptions.new
    config.rcharts.series_color_classes = %w[blue red green orange purple]
    config.rcharts.series_symbols = %w[● ■ ◆ ▲ ▼]

    initializer 'rcharts.configure' do |app|
      RCharts.series_color_classes = app.config.rcharts.series_color_classes
      RCharts.series_symbols = app.config.rcharts.series_symbols
    end

    initializer 'rcharts.types' do
      ActiveModel::Type.register :'rcharts/percentage', RCharts::Type::Percentage
      ActiveModel::Type.register :'rcharts/symbol', RCharts::Type::Symbol
    end
  end
end
