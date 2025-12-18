# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    class GraphBuilderTest < ActionView::TestCase
      setup do
        @builder = GraphBuilder.new(graphable: { 2000 => { predicted: 42, actual: 43 }, 2001 => { predicted: 44, actual: 45 },
                                                 2002 => { predicted: 46, actual: 47 } },
                                    gutter: 15.0, axis_options: { x: { discrete: true } }, series_options: { predicted: { color: 'red' } })
        @blank_builder = GraphBuilder.new
      end

      test 'renders series' do
        render @builder do |graph|
          graph.series &:line
        end

        assert_select '.series-path', count: 2
        assert_select '.series-path.red', count: 1
      end

      test 'renders series with blank builder' do
        render @blank_builder do |graph|
          graph.series &:line
        end

        assert_not_select '.series-path'
      end

      test 'renders categories' do
        render @builder do |graph|
          graph.categories &:bar
        end

        assert_select '.series-shape', count: 6
        assert_select '.series-shape.red', count: 3
      end

      test 'renders categories with blank builder' do
        render @blank_builder do |graph|
          graph.categories &:bar
        end

        assert_not_select '.series-shape'
      end

      test 'renders axis' do
        render @builder do |graph|
          graph.axis :x, &:to_s
        end

        assert_select '.axis-tick-text', '2000'
      end

      test 'renders axis with blank builder' do
        render @blank_builder do |graph|
          graph.axis :x, &:to_s
        end

        assert_not_select '.axis-tick-text'
      end

      test 'renders rules' do
        render @builder do |graph|
          graph.rules :y
        end

        assert_select '.grid-rule'
      end

      test 'renders rules with blank builder' do
        render @blank_builder do |graph|
          graph.rules :y
        end

        assert_not_select '.grid-rule'
      end

      test 'renders legend' do
        render @builder do |graph|
          graph.legend do |item|
            item.name.to_s
          end
        end

        assert_select '.legend-item', 'predicted'
      end

      test 'renders legend with blank builder' do
        render @blank_builder do |graph|
          graph.legend do |item|
            item.name.to_s
          end
        end

        assert_not_select '.legend-item'
      end

      test 'renders tooltips' do
        render @builder do |graph|
          graph.tooltips do |tooltip|
            tooltip.name.to_s
          end
        end

        assert_select '.tooltip-content', '2000'
      end

      test 'renders tooltips with blank builder' do
        render @blank_builder do |graph|
          graph.tooltips do |tooltip|
            tooltip.name.to_s
          end
        end

        assert_not_select '.tooltip-content'
      end
    end
  end
end
