# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class MarkerElementTest < ActionView::TestCase
        setup do
          @element = MarkerElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <line x1="0.0%" x2="100.0%" class="tooltip-marker" />
          HTML
        end

        test 'renders element with inline position' do
          @element.inline_position = 50

          render @element

          assert_select '.tooltip-marker[y1="50.0%"][y2="50.0%"]'
        end

        test 'renders element with inline axis' do
          @element.inline_axis = :x

          render @element

          assert_select '.tooltip-marker[y1="0.0%"][y2="100.0%"]'
        end
      end
    end
  end
end
