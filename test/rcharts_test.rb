# frozen_string_literal: true

require 'test_helper'

class RChartsTest < ActiveSupport::TestCase
  test 'has version number' do
    assert_not_empty RCharts::VERSION
  end

  test 'returns color class for index' do
    assert_not_empty RCharts.color_class_for(0)
    assert_not_empty RCharts.color_class_for(RCharts.series_color_classes.size)
  end

  test 'returns symbol for index' do
    assert_not_empty RCharts.symbol_for(0)
    assert_not_empty RCharts.symbol_for(RCharts.series_symbols.size)
  end
end
