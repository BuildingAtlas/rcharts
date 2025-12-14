# frozen_string_literal: true

require 'rcharts/version'
require 'rcharts/engine'

module RCharts
  extend ActiveSupport::Autoload

  mattr_accessor :series_color_classes, default: %w[blue red green orange purple]
  mattr_accessor :series_symbols, default: %w[● ■ ◆ ▲ ▼]

  autoload :Percentage
  autoload :Type

  def self.color_class_for(index)
    series_color_classes[index % series_color_classes.size]
  end

  def self.symbol_for(index)
    series_symbols[index % series_symbols.size]
  end
end
