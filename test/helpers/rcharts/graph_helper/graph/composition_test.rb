# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class CompositionTest < ActiveSupport::TestCase
        setup do
          @graphable = { 2010 => { predicted: 42, actual: 43 }, 2011 => { predicted: 44, actual: -45 } }
          @composition = Composition.new(@graphable)
          @blank_composition = Composition.new
        end

        test 'returns axes' do
          assert_kind_of Axes, @composition.axes
          assert_kind_of Axes, @blank_composition.axes
        end

        test 'returns keys' do
          assert_not_empty @composition.keys
          assert_empty @blank_composition.keys
        end

        test 'returns values' do
          assert_not_empty @composition.values
          assert_empty @blank_composition.values
        end

        test 'delegates sum complete to calculator' do
          assert_equal 85, @composition.sum_complete[2010]
          assert_empty @blank_composition.sum_complete
        end

        test 'delegates signed to calculator' do
          assert_nil @composition.signed(:positive).dig(:actual, 2011)
          assert_not_nil @composition.signed(:positive).dig(:actual, 2010)
          assert_empty @blank_composition.signed(:positive)[nil]
        end

        test 'delegates stacked to calculator' do
          assert_equal 85, @composition.stacked.dig(:actual, 2010)
          assert_empty @blank_composition.stacked[nil]
        end
      end
    end
  end
end
