# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Categories
      class CategoryBuilderTest < ActionView::TestCase
        setup do
          @composition = Graph::Composition.new({ 2000 => { predicated: 25, actual: 40 },
                                                  2001 => { predicated: 20, actual: 30 } })
          @builder = CategoryBuilder.new
        end

        test 'renders bar' do
          render @builder, &:bar

          assert_dom_equal <<~HTML, rendered
            <svg x="-30.0%" width="60.0%" height="100.0%" class="category"></svg>
          HTML
        end

        test 'renders bar with options' do
          @builder.assign_attributes(category: { predicated: 25, actual: 40 }, index: 2, values_count: 12, name: 2000,
                                     series_options: { predicted: { color_class: 'red' }, actual: {} },
                                     layout_axes: @composition.axes)

          render @builder, &:bar

          assert_dom_equal <<~HTML, rendered
            <svg x="17.5%" width="5.0%" height="100.0%" class="category">
              <rect x="0.0%" y="75.0%" height="125.0%" width="50.0%" class="series-shape blue"></rect>
              <rect x="50.0%" y="0.0%" height="200.0%" width="50.0%" class="series-shape red"></rect>
            </svg>
          HTML
        end

        test 'renders series' do
          render @builder do |category|
            category.series(&:bar)
          end

          assert_dom_equal <<~HTML, rendered
            <svg x="-30.0%" width="60.0%" height="100.0%" class="category"></svg>
          HTML
        end

        test 'renders series with options' do
          @builder.assign_attributes(category: { predicated: 25, actual: 40 }, index: 2, values_count: 12, name: 2000,
                                     series_options: { predicted: { color_class: 'red' }, actual: {} },
                                     layout_axes: @composition.axes)

          render @builder do |category|
            category.series(&:bar)
          end

          assert_dom_equal <<~HTML, rendered
            <svg x="17.5%" width="5.0%" height="100.0%" class="category">
              <rect x="0.0%" y="75.0%" height="125.0%" width="50.0%" class="series-shape blue"></rect>
              <rect x="50.0%" y="0.0%" height="200.0%" width="50.0%" class="series-shape red"></rect>
            </svg>
          HTML
        end
      end
    end
  end
end
