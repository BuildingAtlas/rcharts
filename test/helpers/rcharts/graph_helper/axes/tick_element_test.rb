# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Axes
      class TickElementTest < ActionView::TestCase
        setup do
          @element = TickElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <svg class="axis-tick" x="100.0%" y="100.0%">
              <text class="axis-tick-text" data-inline-axis-index="0"></text>
            </svg>
          HTML
        end

        test 'renders element with value' do
          @element.value = '42'

          render @element

          assert_select '.axis-tick-text', '42'
        end

        test 'renders element with value and block' do
          @element.value = 42

          render @element do |value|
            number_to_human_size value
          end

          assert_select '.axis-tick-text', '42 Bytes'
        end

        test 'renders element with position' do
          @element.position = 42.0

          render @element

          assert_select '.axis-tick[x="100.0%"][y="58.0%"]'
        end

        test 'renders element on vertical axis' do
          @element.assign_attributes(position: 42.0, inline_axis: :y)

          render @element

          assert_select '.axis-tick[x="100.0%"][y="58.0%"]'
          assert_select '.axis-tick-text[data-inline-axis="y"][data-inline-axis-index="0"]'
        end

        test 'renders element on second vertical axis' do
          @element.assign_attributes(position: 42.0, inline_axis: :y, inline_axis_index: 1)

          render @element

          assert_select '.axis-tick[x="0.0%"][y="58.0%"]'
          assert_select '.axis-tick-text[data-inline-axis="y"][data-inline-axis-index="1"]'
        end

        test 'renders element on horizontal axis' do
          @element.assign_attributes(position: 42.0, inline_axis: :x)

          render @element

          assert_select '.axis-tick[x="42.0%"][y="0.0%"]'
          assert_select '.axis-tick-text[data-inline-axis="x"][data-inline-axis-index="0"]'
        end

        test 'renders element on second horizontal axis' do
          @element.assign_attributes(position: 42.0, inline_axis: :x, inline_axis_index: 1)

          render @element

          assert_select '.axis-tick[x="42.0%"][y="0.0%"]'
          assert_select '.axis-tick-text[data-inline-axis="x"][data-inline-axis-index="1"]'
        end
      end
    end
  end
end
