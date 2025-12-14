# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class ForeignObjectElementTest < ActionView::TestCase
        setup do
          @element = ForeignObjectElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <foreignObject width="100.0%" height="0.0%" y="0.0%" class="tooltip-object">
              <div class="tooltip-container justify-end"></div>
            </foreignObject>
          HTML
        end

        test 'renders element with inline position' do
          @element.inline_position = 50

          render @element

          assert_select '.tooltip-object[y="50.0%"]'
        end

        test 'renders element with inline axis' do
          @element.inline_axis = :x

          render @element

          assert_select '.tooltip-object[x="0.0%"]'
        end

        test 'renders element with values count' do
          @element.values_count = 2

          render @element

          assert_not_select '.tooltip-container.anchor-end'
        end

        test 'renders element with index' do
          @element.assign_attributes(index: 1, values_count: 2)

          render @element

          assert_select '.tooltip-container.anchor-end'
        end
      end
    end
  end
end
