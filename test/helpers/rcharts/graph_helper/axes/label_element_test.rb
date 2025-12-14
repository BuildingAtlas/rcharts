# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Axes
      class LabelElementTest < ActionView::TestCase
        setup do
          @element = LabelElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <svg class="axis-label" overflow="visible" width="1lh" height="100.0%">
              <svg x="50%" y="50%" overflow="visible">
                <text class="axis-label-text"></text>
              </svg>
            </svg>
          HTML
        end

        test 'renders element with label' do
          @element.label = 'My favorite axis'

          render @element

          assert_select '.axis-label-text', 'My favorite axis'
        end

        test 'renders element on horizontal axis' do
          @element.horizontal = true

          render @element

          assert_select '.axis-label[width="100.0%"][height="1lh"]'
        end
      end
    end
  end
end
