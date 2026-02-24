# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class PositioningTest < ActiveSupport::TestCase
          module Integration
            module Tests
              extend ActiveSupport::Concern

              included do
                test 'positioning works with exact domain bounds for dates' do
                  @axis.assign_attributes(graphable: [Date.new(2026, 2, 21), Date.new(2027, 2, 21), Date.new(2028, 2, 21),
                                                      Date.new(2029, 2, 21), Date.new(2030, 2, 21), Date.new(2031, 2, 21)]
                                                     .index_with(&:to_time),
                                          values_method: :keys)

                  assert_in_delta 0.0, @axis.position_for(Date.new(2026, 2, 21)), 0.01
                  assert_in_delta 100.0, @axis.position_for(Date.new(2031, 2, 21)), 0.01
                end

                test 'positioning works with exact domain bounds for times' do
                  @axis.assign_attributes(graphable: [Time.new(2025, 1, 1, 12, 0, 0).in_time_zone,
                                                      Time.new(2025, 1, 2, 12, 0, 0).in_time_zone].index_with(&:to_f),
                                          values_method: :keys)

                  assert_in_delta 0.0, @axis.position_for(Time.new(2025, 1, 1, 12, 0, 0).in_time_zone), 0.01
                  assert_in_delta 100.0, @axis.position_for(Time.new(2025, 1, 2, 12, 0, 0).in_time_zone), 0.01
                end

                test 'positioning works with rounded domain bounds' do
                  @axis.assign_attributes(graphable: [2150, 3200, 5800, 8328].index_with(&:itself), values_method: :values)

                  assert_operator @axis.position_for(2150), :>, 0
                  assert_in_delta 0.0, @axis.position_for(2000), 0.01
                end

                test 'preserves existing positioning behavior for integer keys' do
                  @axis.assign_attributes(graphable: { 10 => 1.0, 20 => 2.0, 30 => 3.0 }, values_method: :keys)

                  assert_in_delta 0.0, @axis.position_for(10), 0.01
                  assert_in_delta 100.0, @axis.position_for(30), 0.01
                end
              end
            end
          end

          include Integration::Tests

          setup do
            @axis = Axis.new(values_method: :keys,
                             graphable: { 0.5 => -233, 10.5 => 12, 30.0 => 40, 35.0 => nil, 50.0 => 802 })
          end

          test 'calculates tick positions and values' do
            assert_equal 11, @axis.ticks.keys.count
            assert_in_delta 50.0, @axis.ticks.keys.sum / @axis.ticks.keys.count
          end

          test 'returns nil if values are empty' do
            @axis.graphable = {}

            assert_nil @axis.value_at(0)
          end

          test 'returns empty hash if no ticks' do
            @axis.graphable = {}

            assert_empty @axis.ticks
          end

          test 'handles small tick counts' do
            @axis.graphable = { 0 => 42.0 }

            assert_equal 1, @axis.ticks.size
          end

          test 'handles large tick counts' do
            @axis.graphable = (0..17_000).index_with(Random.rand(42.0))

            assert_equal 10, @axis.ticks.size
          end

          test 'handles integer ticks' do
            @axis.graphable = (0..75).index_with(&:to_f)

            assert_equal 9, @axis.ticks.size
          end

          test 'handles float ticks' do
            @axis.graphable = [0.5, 10.5, 30.0, 35.0, 50.0].index_with(&:itself)

            assert_equal 11, @axis.ticks.size
          end

          test 'handles date ticks' do
            @axis.graphable = [Date.new(2025, 1, 1), Date.new(2025, 1, 2)].index_with(&:to_time)

            assert_equal 9, @axis.ticks.size
          end

          test 'handles time ticks' do
            @axis.graphable = [Time.new(2025, 1, 1), Time.new(2025, 1, 2)].index_with(&:to_f) # rubocop:disable Rails/TimeZone

            assert_equal 9, @axis.ticks.size
          end

          test 'returns position at index' do
            assert_in_delta 20.0, @axis.position_at(2)
          end

          test 'handles position at index with zero tick count' do
            @axis.graphable = {}

            assert_nil @axis.position_at(1)
          end

          test 'handles position at out of bounds index' do
            assert_nil @axis.position_at(100_000_000)
          end

          test 'returns value at index with discrete data' do
            @axis.assign_attributes(graphable: { 'a' => 'a', 'b' => 'b', 'c' => 'c' },
                                    discrete: :categorical)

            assert_equal 'a', @axis.value_at(0)
            assert_equal 'b', @axis.value_at(1)
            assert_equal 'c', @axis.value_at(2)
          end

          test 'handles value at out of bounds index' do
            @axis.graphable = { 1 => 'a', 2 => 'b' }

            assert_nil @axis.value_at(-1)
            assert_nil @axis.value_at(20_000)
          end

          test 'returns value at index with continuous data' do
            @axis.graphable = { 10 => 1.0, 15 => 2.0, 20 => 3.0 }

            assert_equal 10, @axis.value_at(0)
            assert_equal 14, @axis.value_at(4)
            assert_equal 19, @axis.value_at(9)
          end

          test 'returns position for categorical data' do
            @axis.assign_attributes(graphable: { 'a' => 'a', 'b' => 'b', 'c' => 'c', 'd' => 'd' },
                                    discrete: :categorical)

            assert_in_delta 12.5, @axis.position_for('a')
            assert_in_delta 37.5, @axis.position_for('b')
            assert_in_delta 87.5, @axis.position_for('d')
          end

          test 'returns position for single category' do
            @axis.assign_attributes(graphable: { 'a' => 1.0 }, discrete: :categorical)

            assert_in_delta 50.0, @axis.position_for('a')
          end

          test 'returns position for continuous data' do
            @axis.graphable = { 14 => 1.0, 22 => 2.0, 55 => 3.0 }

            assert_in_delta 0.0, @axis.position_for(10)
            assert_in_delta 44.444, @axis.position_for(30)
            assert_in_delta 88.888, @axis.position_for(50)
          end

          test 'returns position for value below minimum' do
            @axis.graphable = { 14 => 1.0, 22 => 2.0, 55 => 3.0 }

            assert_in_delta 0 - 44.444, @axis.position_for(-10)
          end

          test 'returns position for value above maximum' do
            @axis.graphable = { 14 => 1.0, 22 => 2.0, 55 => 3.0 }

            assert_in_delta 133.333, @axis.position_for(70)
          end
        end
      end
    end
  end
end
