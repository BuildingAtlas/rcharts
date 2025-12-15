# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipElementTest < ActionView::TestCase
        setup do
          @element = TooltipElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <g class="tooltip">
              <rect y="0.0%" width="100.0%" height="0.0%" class="tooltip-hover-target" />
              <line x1="0.0%" x2="100.0%" y1="0.0%" y2="0.0%" class="tooltip-marker" />
              <foreignObject width="100.0%" height="0.0%" y="0.0%" class="tooltip-object">
                <div class="tooltip-container justify-end">
                  <div class="tooltip-content"></div>
                </div>
              </foreignObject>
            </g>
          HTML
        end

        test 'renders element with inline position' do
          @element.inline_position = 50

          render @element

          assert_select '.tooltip-hover-target[y="50.0%"]'
        end

        test 'renders element with inline size' do
          @element.inline_size = 50

          render @element

          assert_select '.tooltip-hover-target[height="50.0%"]'
        end

        test 'renders element with inline axis' do
          @element.inline_axis = :x

          render @element

          assert_select '.tooltip-marker[y1="0.0%"][y2="100.0%"]'
        end

        test 'renders element with values count' do
          @element.values_count = 2

          render @element

          assert_select '.tooltip-container.justify-end'
        end

        test 'renders element with index' do
          @element.assign_attributes(index: 0, values_count: 2, inline_axis: :x)

          render @element

          assert_not_select '.tooltip-container.justify-end'
        end
      end
    end
  end
end
