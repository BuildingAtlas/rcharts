# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class TicksTest < ActiveSupport::TestCase
          module Integration
            module Tests
              extend ActiveSupport::Concern

              included do
                test 'independent axis with dates uses exact bounds for bounds' do
                  @axis.assign_attributes(graphable: [Date.new(2026, 2, 21), Date.new(2027, 2, 21), Date.new(2028, 2, 21),
                                                      Date.new(2029, 2, 21), Date.new(2030, 2, 21), Date.new(2031, 2, 21)]
                                                     .index_with(&:to_time),
                                          values_method: :keys)

                  assert_equal Date.new(2026, 2, 21), @axis.adjusted_minimum
                  assert_equal Date.new(2031, 2, 21), @axis.adjusted_maximum
                end

                test 'dependent axis with integers still rounds to nice minimum' do
                  @axis.assign_attributes(graphable: [2150, 3200, 5800, 8328].index_with(&:itself), values_method: :values)

                  assert_equal 2000, @axis.adjusted_minimum
                  assert_equal 9000, @axis.adjusted_maximum
                end

                test 'independent axis with times uses exact bounds' do
                  @axis.assign_attributes(graphable: [Time.new(2025, 1, 1, 12, 30, 0).in_time_zone,
                                                      Time.new(2025, 1, 1, 14, 45, 0).in_time_zone]
                                                     .index_with(&:to_f),
                                          values_method: :keys)

                  assert_equal Time.new(2025, 1, 1, 12, 30, 0).in_time_zone, @axis.adjusted_minimum
                  assert_equal Time.new(2025, 1, 1, 14, 45, 0).in_time_zone, @axis.adjusted_maximum
                end

                test 'dependent X-axis rounds values' do
                  @axis.assign_attributes(graphable: [42, 157, 283].index_with(&:itself), values_method: :values)

                  assert_equal 25, @axis.adjusted_minimum.to_i
                end

                test 'independent Y-axis uses exact bounds for categories' do
                  @axis.assign_attributes(graphable: ['Category A', 'Category B', 'Category C'].index_with { [it] },
                                          values_method: :keys, discrete: true)

                  assert_equal 3, @axis.tick_count
                end
              end
            end
          end

          include Integration::Tests

          setup do
            @axis = Axis.new
          end

          test 'returns tick count for categorical data' do
            @axis.assign_attributes(graphable: (1..9).index_with(&:to_f), discrete: :categorical, values_method: :keys)

            assert_equal 8, @axis.tick_count
          end

          test 'returns tick count for discrete data' do
            @axis.assign_attributes(graphable: (1..9).index_with(&:to_f), discrete: true, values_method: :keys)

            assert_equal 9, @axis.tick_count
          end

          test 'returns tick count for continuous data with integers' do
            @axis.assign_attributes(graphable: (1..100).index_with(&:to_f), values_method: :values)

            assert_equal 10, @axis.tick_count
          end

          test 'returns tick count for continuous data with floats' do
            @axis.assign_attributes(graphable: [0.5, 10.5, 5].index_with(&:itself), values_method: :values)

            assert_equal 11, @axis.tick_count
          end

          test 'returns tick count with adjusted minimum' do
            @axis.assign_attributes(graphable: [0.5, 10.5, 5].index_with(&:itself), minimum: 5, values_method: :values)

            assert_equal 6, @axis.tick_count
          end

          test 'handles zero tick interval gracefully' do
            @axis.assign_attributes(graphable: [5, 5, 5].index_with(&:itself), values_method: :keys)

            assert_predicate @axis.tick_count, :zero?
          end

          test 'returns tick count with times with zones' do
            @axis.assign_attributes(graphable: [Time.new(2025, 1, 1).in_time_zone,
                                                Time.new(2025, 1, 2).in_time_zone].index_with(&:to_f),
                                    values_method: :keys)

            assert_equal 12, @axis.tick_count
          end

          test 'returns tick count with times' do
            @axis.assign_attributes(graphable: [Time.new(2025, 1, 1), Time.new(2025, 1, 2)].index_with(&:to_f), # rubocop:disable Rails/TimeZone
                                    values_method: :keys)

            assert_equal 12, @axis.tick_count
          end

          test 'returns tick count with dates' do
            @axis.assign_attributes(graphable: [Date.new(2025, 1, 1), Date.new(2025, 1, 2)].index_with(&:to_time),
                                    values_method: :keys)

            assert_equal 12, @axis.tick_count
          end

          test 'returns adjusted minimum' do
            @axis.assign_attributes(graphable: [3, 8, 12, 16].index_with(&:to_f), values_method: :values)

            assert_equal 2, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with explicit minimum' do
            @axis.assign_attributes(minimum: 5, graphable: [4, 8, 12, 16].index_with(&:to_f), values_method: :values)

            assert_equal 4, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with time keys for exact bounds' do
            @axis.assign_attributes(graphable: [Time.new(2025, 1, 1).in_time_zone,
                                                Time.new(2025, 1, 2).in_time_zone,
                                                Time.new(2025, 1, 3).in_time_zone].index_with(&:to_f),
                                    values_method: :keys)

            assert_equal Time.new(2025, 1, 1).in_time_zone, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with single key' do
            @axis.assign_attributes(graphable: [5].index_with(&:itself), values_method: :keys)

            assert_equal 5, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with float values' do
            @axis.assign_attributes(graphable: [7.9, 8.1, 8.9, 10.5].index_with(&:itself), values_method: :values)

            assert_in_delta 7.5, @axis.adjusted_minimum
          end
        end
      end
    end
  end
end
