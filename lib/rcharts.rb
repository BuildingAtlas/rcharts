# frozen_string_literal: true

require 'rcharts/version'
require 'rcharts/engine'

# = \RCharts
#
# \RCharts is a simple but highly extensible and customizable framework for rendering charts with Action View.
# Unlike many other charting libraries, \RCharts produces charts with non-uniform scaling without resorting to any
# client-side rendering, so that the browser has enough information to be able to resize the chart itself.
# You can then progressively enhance this baseline functionality to achieve things like panning and zooming,
# without needing to consider how and when the chart is rendered.
#
# To get started rendering charts, see GraphHelper.
module RCharts
  extend ActiveSupport::Autoload

  mattr_accessor :series_color_classes, default: %w[blue red green orange purple]
  mattr_accessor :series_symbols, default: %w[● ■ ◆ ▲ ▼]

  autoload :Percentage
  autoload :Type

  # Returns a color class based on the index.
  # You can set the color classes using <tt>Rails.application.config.rcharts.series_color_classes=</tt>.
  #
  #   module MyApplication
  #     class Application < Rails::Application
  #       config.rcharts.series_color_classes = %w[blue red green]
  #     end
  #   end
  #
  #   RCharts.color_class_for(1) # => 'red'
  def self.color_class_for(index)
    series_color_classes[index % series_color_classes.size]
  end

  # Returns a symbol based on the index.
  # You can set the symbols using <tt>Rails.application.config.rcharts.series_symbols=</tt>.
  # Symbols are characters like ●, ■, ◆, ▲, ▼.
  #
  #   module MyApplication
  #     class Application < Rails::Application
  #       config.rcharts.series_symbols = %w[● ■ ◆ ▲ ▼]
  #     end
  #   end
  #
  #   RCharts.symbol_for(1) # => '■'
  def self.symbol_for(index)
    series_symbols[index % series_symbols.size]
  end
end
