# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipBuilderTest < ActionView::TestCase
        setup do
          @builder = TooltipBuilder.new
        end

        test 'renders series' do
          @builder.series_options.merge!(series_one: { color_class: 'kiwi', symbol: '★' }, series_two: {})
          render @builder do |tooltip|
            tooltip.series(&:symbol)
          end

          assert_dom_equal <<~HTML, rendered
            <div>
              <span class="series-symbol kiwi">★</span>
            </div>
            <div>
              <span class="series-symbol red">■</span>
            </div>
          HTML
        end

        test 'renders series with name' do
          @builder.assign_attributes(name: 'Miranda', series_options: { series_one: { name: 'Series One' }, series_two: {} })
          render @builder do |tooltip|
            tag.h4(tooltip.name)
          end

          assert_dom_equal <<~HTML, rendered
            <h4>Miranda</h4>
          HTML
        end

        test 'renders series with values' do
          @builder.assign_attributes(series_options: { series_one: {}, series_two: {} },
                                     values: { series_one: 1, series_two: 2 })
          render @builder do |tooltip|
            tooltip.series do |series|
              tag.span series.value
            end
          end

          assert_dom_equal <<~HTML, rendered
            <div>
              <span>1</span>
            </div>
            <div>
              <span>2</span>
            </div>
          HTML
        end
      end
    end
  end
end
