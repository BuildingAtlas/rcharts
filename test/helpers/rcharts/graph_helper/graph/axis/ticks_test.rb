# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class TicksTest < ActiveSupport::TestCase
          setup do
            @axis = Axis.new
          end

          test 'returns tick count for discrete data' do
            @axis.assign_attributes(graphable: (1..9).index_with(&:to_f), discrete: true, values_method: :keys)

            assert_equal 8, @axis.tick_count
          end

          test 'returns tick count for continuous data with integers' do
            @axis.assign_attributes(graphable: (1..100).index_with(&:to_f), values_method: :keys)

            assert_equal 10, @axis.tick_count
          end

          test 'returns tick count for continuous data with floats' do
            @axis.assign_attributes(graphable: [0.5, 10.5, 5].index_with(&:itself), values_method: :keys)

            assert_equal 11, @axis.tick_count
          end

          test 'returns tick count with adjusted minimum' do
            @axis.assign_attributes(graphable: [0.5, 10.5, 5].index_with(&:itself), minimum: 5, values_method: :keys)

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

            assert_equal 10, @axis.tick_count
          end

          test 'returns adjusted minimum' do
            @axis.assign_attributes(graphable: [3, 8, 12, 16].index_with(&:to_f), values_method: :keys)

            assert_equal 2, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with explicit minimum' do
            @axis.assign_attributes(minimum: 5, graphable: [4, 8, 12, 16].index_with(&:to_f), values_method: :keys)

            assert_equal 4, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with time keys' do
            @axis.assign_attributes(graphable: [Time.new(2025, 1, 1).in_time_zone,
                                                Time.new(2025, 1, 2).in_time_zone,
                                                Time.new(2025, 1, 3).in_time_zone].index_with(&:to_f),
                                    values_method: :keys)

            assert_equal Time.new(2024, 12, 31, 23).in_time_zone, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with single key' do
            @axis.assign_attributes(graphable: [5].index_with(&:itself), values_method: :keys)

            assert_equal 5, @axis.adjusted_minimum
          end

          test 'returns adjusted minimum with float keys' do
            @axis.assign_attributes(graphable: [7.9, 8.1, 8.9, 10.5].index_with(&:itself), values_method: :keys)

            assert_in_delta 7.5, @axis.adjusted_minimum
          end
        end
      end
    end
  end
end
