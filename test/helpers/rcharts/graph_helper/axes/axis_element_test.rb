# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Axes
      class AxisElementTest < ActionView::TestCase
        setup do
          @element = AxisElement.new
        end

        test 'renders element' do
          assert_dom_equal render_erb(<<~HTML, axis_id: @element.hash.abs), render(@element)
            <style></style>
            <div class="axis" data-index="0">
              <svg class="axis-ticks" data-axis="<%= axis_id %>"></svg>
            </div>
          HTML
        end

        test 'renders element with name' do
          @element.name = :x

          render @element

          assert_select '.axis[data-name="x"]'
        end

        test 'renders element with index' do
          @element.index = 1

          render @element

          assert_select '.axis[data-index="1"]'
        end

        test 'renders element with ticks' do
          @element.ticks = { 10.0 => 15.3, 20.0 => 25.6, 30.0 => 35.9 }

          render @element

          assert_select '.axis-tick', count: 3
          assert_select '.axis-tick[x="100.0%"][y="90.0%"]'
        end

        test 'renders element with label' do
          @element.label = 'Axis label'

          render @element

          assert_select '.axis-label-text', 'Axis label'
        end

        test 'renders element on horizontal axis' do
          @element.horizontal = true

          render @element

          assert_select 'style', /@container/
        end

        test 'renders element on vertical axis with block' do
          @element.assign_attributes(ticks: { 10.0 => 15.3, 20.0 => 25.6, 30.0 => 35.9 })

          render @element do |value|
            number_to_human value
          end

          assert_select '.axis-ticks[width]'
        end
      end
    end
  end
end
