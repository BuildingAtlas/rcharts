# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Categories
      class BarSegmentElementTest < ActionView::TestCase
        setup do
          @element = BarSegmentElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <rect x="0.0%" y="100.0%" height="100.0%" width="100.0%" class="series-shape blue" />
          HTML
        end

        test 'renders element on horizontal axis' do
          @element.horizontal = true

          render @element

          assert_select '.series-shape[y="0.0%"][x="0.0%"]'
        end

        test 'renders element with inline size' do
          @element.inline_size = 50

          render @element

          assert_select '.series-shape[width="50.0%"]'
        end

        test 'renders element with block size' do
          @element.block_size = 50

          render @element

          assert_select '.series-shape[height="50.0%"]'
        end

        test 'renders element with block position' do
          @element.block_position = 50

          render @element

          assert_select '.series-shape[y="50.0%"]'
        end

        test 'renders element with inline index' do
          @element.assign_attributes(inline_index: 1, inline_size: 50)

          render @element

          assert_select '.series-shape[x="50.0%"][width="50.0%"]'
        end

        test 'renders element with series index' do
          @element.series_index = 1

          render @element

          assert_select '.series-shape.red'
        end

        test 'renders element with series options' do
          @element.series_options = { color_class: 'lime' }

          render @element

          assert_select '.series-shape.lime'
        end
      end
    end
  end
end
