# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Categories
      class BarBuilderTest < ActionView::TestCase
        setup do
          @builder = BarBuilder.new
        end

        test 'renders bar' do
          assert_dom_equal <<~HTML, render(@builder, &:bar)
            <rect x="0.0%" y="100.0%" height="100.0%" width="100.0%" class="series-shape blue" />
          HTML
        end

        test 'renders bar with options' do
          @builder.assign_attributes(name: :predicted, inline_size: Percentage.new(25), block_size: Percentage.new(40),
                                     block_position: Percentage.new(50), inline_index: 2, series_index: 2,
                                     horizontal: true, series_options: { color_class: 'red' })

          assert_dom_equal <<~HTML, render(@builder, &:bar)
            <rect x="50.0%" y="50.0%" height="25.0%" width="40.0%" class="series-shape red" />
          HTML
        end
      end
    end
  end
end
