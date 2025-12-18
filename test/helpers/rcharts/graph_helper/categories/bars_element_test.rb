# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Categories
      class BarsElementTest < ActionView::TestCase
        setup do
          @element = BarsElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <svg y="70.0%" width="100.0%" height="60.0%" class="category"></svg>
          HTML
        end

        test 'renders element with index' do
          @element.assign_attributes(index: 2, values_count: 3)

          render @element

          assert_select '.category[y="90.0%"][height="20.0%"]'
        end

        test 'renders element with values count' do
          @element.values_count = 3

          render @element

          assert_select '.category[y="90.0%"][height="20.0%"]'
        end

        test 'renders element with inline position' do
          @element.inline_position = 30

          render @element

          assert_select '.category[y="40.0%"]'
        end

        test 'renders element on horizontal axis' do
          @element.horizontal = true

          render @element

          assert_select '.category[height="100.0%"]'
        end
      end
    end
  end
end
