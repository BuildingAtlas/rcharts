# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class ScatterElementTest < ActionView::TestCase
        setup do
          @element = ScatterElement.new
        end

        test 'renders element' do
          assert_dom_equal render_erb(<<~HTML, id_hash: @element.id_hash), render(@element)
            <g>
              <defs>
                <symbol id="<%= id_hash%>-marker" x="-6.0" y="-6.0" width="12.0" height="12.0">
                  <line x1="2.0" x2="10.0" y1="2.0" y2="10.0" class="series-path" />
                  <line x1="10.0" x2="2.0" y1="2.0" y2="10.0" class="series-path" />
                </symbol>
              </defs>
              <g></g>
            </g>
          HTML
        end

        test 'renders element with marker size' do
          @element.assign_attributes(series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 }, marker_size: 42)

          render @element

          assert_select '.series-path[x1="42.0"]', count: 1
          assert_select '.series-path[x2="42.0"]', count: 1
        end

        test 'renders element with marker margin' do
          @element.assign_attributes(series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 }, marker_margin: 42)

          render @element

          assert_select '.series-path[x1="42.0"]', count: 1
          assert_select '.series-path[x2="42.0"]', count: 1
        end
      end
    end
  end
end
