# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class CalculatorTest < ActiveSupport::TestCase
        VALUES = { 1 => { first: 1, second: 2, third: 1 }, 2 => { first: 20.0, second: -30.0, third: 40 },
                   3 => { first: -14.0, second: -20.0, third: nil } }.freeze

        setup do
          @calculator = Calculator.new(VALUES)
          @empty_calculation = Calculator.new
        end

        test 'selects positive and negative values' do
          assert_equal VALUES.keys, @calculator.to_h.values.first.keys
          assert_equal VALUES.values.pluck(:first), @calculator[:first].values
        end

        test 'selects positive values' do
          @calculator.signed(:positive)[:first]
                     .values
                     .difference(VALUES.values.pluck(:first).select(&:positive?))
                     .then do |difference|
                       assert_not_empty difference
                       assert difference.all?(&:nil?)
          end
        end

        test 'selects negative values' do
          @calculator.signed(:negative)[:first]
                     .values
                     .difference(VALUES.values.pluck(:first).select(&:negative?))
                     .then do |difference|
                       assert_not_empty difference
                       assert difference.all?(&:nil?)
          end
        end

        test 'selects stacked values' do
          assert_equal VALUES.values.pluck(:first), @calculator.stacked[:first].values
          assert_not_equal VALUES.values.pluck(:second), @calculator.stacked[:second]
          assert_equal VALUES.values.pluck(:first)
                             .zip(VALUES.values.pluck(:second))
                             .collect { |first, second| first + second },
                       @calculator.stacked[:second].values
        end

        test 'selects previous values' do
          assert_empty @calculator.stacked(exclude_current: true)[:first].values.compact
          assert_equal VALUES.values.pluck(:first),
                       @calculator.stacked(exclude_current: true)[:second].values
        end

        test 'sums complete values' do
          assert_equal VALUES[1].values.sum, @calculator.sum_complete[1]
          assert_equal VALUES[2].values.sum, @calculator.sum_complete[2]
          assert_nil @calculator.sum_complete[3]
        end
      end
    end
  end
end
