# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Legend
      class LegendElementTest < ActionView::TestCase
        setup do
          @element = LegendElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <ul class="legend" data-placement="bottom"></ul>
          HTML
        end

        test 'renders element with series options' do
          @element.series_options.merge!(series_one: { color_class: 'red', symbol: '★' }, series_two: {})

          assert_dom_equal <<~HTML, render(@element, &:dot)
            <ul class="legend" data-placement="bottom">
              <li class="legend-item">
                <span class="series-symbol red">★</span>
              </li>
              <li class="legend-item">
                <span class="series-symbol red">■</span>
              </li>
            </ul>
          HTML
        end

        test 'renders element with custom placement' do
          @element.placement = 'top'

          assert_dom_equal <<~HTML, render(@element)
            <ul class="legend" data-placement="top"></ul>
          HTML
        end
      end
    end
  end
end
