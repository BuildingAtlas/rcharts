# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class HoverTargetElementTest < ActionView::TestCase
        setup do
          @element = HoverTargetElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <rect y="0.0%" width="100.0%" height="0.0%" class="tooltip-hover-target" />
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

          assert_select '.tooltip-hover-target[x="0.0%"]'
        end
      end
    end
  end
end
