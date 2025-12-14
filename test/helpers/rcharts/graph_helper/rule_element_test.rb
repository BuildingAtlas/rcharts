# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    class RuleElementTest < ActionView::TestCase
      setup do
        @element = RuleElement.new
      end

      test 'renders element' do
        assert_dom_equal <<~HTML, render(@element)
          <svg class="grid-rule-container">
            <line x1="0.0%" x2="100.0%" y1="100.0%" y2="100.0%" class="grid-rule" />
          </svg>
        HTML
      end

      test 'renders element on horizontal axis' do
        @element.horizontal_axis = true

        render @element

        assert_select '.grid-rule[x1="0.0%"][x2="0.0%"][y1="0.0%"][y2="100.0%"]'
      end

      test 'renders element in short variant on first horizontal axis' do
        @element.assign_attributes(horizontal_axis: true, axis_index: 0, short: true, gutter: 42.0)

        render @element

        assert_select '.grid-rule-container[y="100%"]'
        assert_select '.grid-rule[y1="0.0%"][y2="21.0"][x1="0.0%"][x2="0.0%"]'
      end

      test 'renders element in short variant on second horizontal axis' do
        @element.assign_attributes(horizontal_axis: true, axis_index: 1, short: true, gutter: 42.0)

        render @element

        assert_not_select '.grid-rule-container[y="100%"]'
        assert_select '.grid-rule[y1="0.0%"][y2="-21.0"][x1="0.0%"][x2="0.0%"]'
      end

      test 'renders element in short variant on first vertical axis' do
        @element.assign_attributes(short: true, gutter: 42.0)

        render @element

        assert_select '.grid-rule[x1="-21.0"][x2="0.0%"][y1="100.0%"][y2="100.0%"]'
      end

      test 'renders element in short variant on second vertical axis' do
        @element.assign_attributes(short: true, gutter: 42.0, axis_index: 1)

        render @element

        assert_select '.grid-rule-container[x="100%"]'
        assert_select '.grid-rule[x1="21.0"][x2="0.0%"][y1="100.0%"][y2="100.0%"]'
      end

      test 'renders element with position' do
        @element.position = 42.0

        render @element

        assert_select '.grid-rule[y1="58.0%"][y2="58.0%"][x1="0.0%"][x2="100.0%"]'
      end

      test 'renders element with position on horizontal axis' do
        @element.assign_attributes(horizontal_axis: true, position: 42.0)

        render @element

        assert_select '.grid-rule[x1="42.0%"][x2="42.0%"][y1="0.0%"][y2="100.0%"]'
      end

      test 'renders element with emphasis' do
        @element.emphasis = true

        render @element

        assert_select '.grid-rule.emphasis'
      end

      test 'renders element with emphasis and value' do
        @element.assign_attributes(emphasis: -> { it == 42 }, value: 41)
        render @element

        assert_not_select '.grid-rule.emphasis'
        @element.value = 42

        render @element

        assert_select '.grid-rule.emphasis'
      end
    end
  end
end
