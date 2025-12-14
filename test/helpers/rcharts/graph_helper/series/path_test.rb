# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class PathTest < ActiveSupport::TestCase
        setup do
          @points = [Point.new(0, 1), Point.new(1, 2), Point.new(2, nil), Point.new(3, 4), Point.new(4, 5),
                     Point.new(5, nil), Point.new(6, nil), Point.new(7, 8)]
          @path = Path.new(@points)
          @smoothed_path = Path.new(@points, smoothing: 0.5)
          @empty_path = Path.new([])
          @path_without_compacted_points = Path.new([Point.new(0, nil), Point.new(1, nil)])
        end

        test 'returns valid line path for compacted points' do
          assert_not_empty @path.line_path
        end

        test 'returns valid line path for compacted points with smoothing' do
          assert_not_empty @smoothed_path.line_path
          assert_not_equal @path.line_path, @smoothed_path.line_path
        end

        test 'returns empty line path for empty compacted points' do
          assert_empty @empty_path.line_path
          assert_empty @path_without_compacted_points.line_path
        end

        test 'returns valid area path for compacted points' do
          assert_not_empty @path.area_path
        end

        test 'returns valid area path for compacted points with smoothing' do
          assert_not_empty @smoothed_path.area_path
          assert_not_equal @path.area_path, @smoothed_path.area_path
        end

        test 'returns empty area path for empty compacted points' do
          assert_empty @empty_path.area_path
        end

        test 'returns mask spans for compacted points' do
          assert_equal 3, @path.mask_spans.size
          assert_operator @points.last.x - @points.first.x, :>, @path.mask_spans.pluck(:width).sum
          assert_predicate @path.mask_spans.pluck(:width).sum, :positive?
        end
      end
    end
  end
end
