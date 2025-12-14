# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class AxesTest < ActiveSupport::TestCase
        setup do
          @graphable = { x: [1, 2, 3], y: [4, 5, 6] }
          @axis_options = { x: { values_method: ->(graphable) { graphable[:x] } },
                            y: { values_method: ->(graphable) { graphable[:y] } } }
          @axes = Axes.new(@graphable, @axis_options)
        end

        test 'fetches correct value for existing axis and index' do
          assert_equal @axes.fetch(:x, 0), @axes[:x][0]
          assert_equal @axes.fetch(:y, 0), @axes[:y][0]
        end

        test 'raises for unknown axis' do
          assert_raises ArgumentError do
            @axes.fetch(:z)
          end
        end

        test 'raises for an unknown index' do
          assert_raises ArgumentError do
            @axes.fetch(:x, 10)
          end
        end

        test 'fetches default index when not provided' do
          assert_equal @axes.fetch(:x), @axes[:x][0]
          assert_equal @axes.fetch(:y), @axes[:y][0]
        end

        test 'returns X axis if discrete' do
          assert_equal @axes[:x][0], @axes.discrete
        end

        test 'returns the first discrete axis if X axis not discrete' do
          @axes[:x][0].discrete = false
          @axes[:y][0].discrete = true

          assert_equal @axes[:y][0], @axes.discrete
        end

        test 'falls back to X axis if no discrete axis' do
          @axes[:x][0].discrete = false
          @axes[:y][0].discrete = false

          assert_equal @axes[:x][0], @axes.discrete
        end

        test 'returns Y axis if not discrete' do
          assert_equal @axes[:y][0], @axes.continuous
        end

        test 'returns first non-discrete axis if Y axis discrete' do
          @axes[:y][0].discrete = true
          @axes[:x][0].discrete = false

          assert_equal @axes[:x][0], @axes.continuous
        end

        test 'falls back to Y axis if no non-discrete axis' do
          @axes[:y][0].discrete = false
          @axes[:x][0].discrete = false

          assert_equal @axes[:y][0], @axes.continuous
        end
      end
    end
  end
end
