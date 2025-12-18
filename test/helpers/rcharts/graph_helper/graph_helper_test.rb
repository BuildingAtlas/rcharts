# frozen_string_literal: true

require 'test_helper'

module RCharts
  class GraphHelperTest < ActionView::TestCase
    setup do
      @graphable = { 2000 => { predicted: 42, actual: 43 }, 2001 => { predicted: 44, actual: 45 }, 2002 => { predicted: 46, actual: 47 } }
    end

    test 'renders graph for graphable' do
      concat graph_for(@graphable)

      assert_select '.rcharts-chart'
    end
  end
end
