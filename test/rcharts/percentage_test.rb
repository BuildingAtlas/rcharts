# frozen_string_literal: true

require 'test_helper'

module RCharts
  class PercentageTest < ActiveSupport::TestCase
    setup do
      @percentage = Percentage.new(42)
    end

    test 'wraps value' do
      assert_equal @percentage, Percentage.wrap(42)
    end

    test 'unwraps value' do
      assert_equal 42, Percentage.unwrap(@percentage)
    end

    test 'returns maximum' do
      assert_kind_of Percentage, Percentage::MAX
    end

    test 'returns minimum' do
      assert_kind_of Percentage, Percentage::MIN
    end

    test 'compares value' do
      assert_equal Percentage.new(42), Percentage.new(42)
    end

    test 'adds to value' do
      assert_equal Percentage.new(84), @percentage + Percentage.new(42)
    end

    test 'subtracts from value' do
      assert_equal Percentage.new(28), @percentage - Percentage.new(14)
    end

    test 'multiplies by value' do
      assert_equal Percentage.new(84), @percentage * 2
    end

    test 'divides by value' do
      assert_equal Percentage.new(21), @percentage / 2
    end

    test 'returns value as string' do
      assert_equal '42.0%', @percentage.to_s
    end
  end
end
