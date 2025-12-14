# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class AxisTest < ActiveSupport::TestCase
        setup do
          @axis = Axis.new
        end

        test 'values method defaults to values' do
          assert_equal :values, @axis.values_method
        end

        test 'stacked defaults to false' do
          assert_not @axis.stacked
        end

        test 'returns true when stacked' do
          @axis.stacked = true

          assert_predicate @axis, :stacked?
        end

        test 'returns false when not stacked' do
          @axis.stacked = false

          assert_not_predicate @axis, :stacked?
        end

        test 'returns true when discrete present' do
          @axis.discrete = 'some value'

          assert_predicate @axis, :discrete?
        end

        test 'returns false when discrete nil' do
          @axis.discrete = nil

          assert_not_predicate @axis, :discrete?
        end

        test 'returns false when discrete empty' do
          @axis.discrete = ''

          assert_not_predicate @axis, :discrete?
        end

        test 'returns true when discrete is categorical' do
          @axis.discrete = :categorical

          assert_predicate @axis, :categorical?
        end

        test 'returns false when discrete is nil' do
          @axis.discrete = nil

          assert_not_predicate @axis, :categorical?
        end

        test 'returns false when discrete is not categorical' do
          @axis.discrete = :ordinal

          assert_not_predicate @axis, :categorical?
        end

        test 'returns true for horizontal axis' do
          @axis.name = :x

          assert_predicate @axis, :horizontal?
        end

        test ' returns false for non-horizontal axis' do
          @axis.name = :y

          assert_not_predicate @axis, :horizontal?
        end

        test 'returns true for vertical axis' do
          @axis.name = :y

          assert_predicate @axis, :vertical?
        end

        test 'returns false for non-vertical axis' do
          @axis.name = :x

          assert_not_predicate @axis, :vertical?
        end
      end
    end
  end
end
