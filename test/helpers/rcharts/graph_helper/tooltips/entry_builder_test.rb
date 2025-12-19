# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class EntryBuilderTest < ActionView::TestCase
        setup do
          @builder = EntryBuilder.new
        end

        test 'returns value' do
          assert_nil @builder.value
          @builder.value = 100

          assert_equal 100, @builder.value
        end

        test 'returns name' do
          assert_nil @builder.name
          @builder.name = :my_series

          assert_equal :my_series, @builder.name
        end

        test 'returns index' do
          assert_predicate @builder.index, :zero?
          @builder.index = 2

          assert_equal 2, @builder.index
        end

        test 'renders symbol' do
          assert_dom_equal <<~HTML, render(@builder, &:symbol)
            <span class="series-symbol blue">●</span>
          HTML
        end

        test 'renders symbol with custom color class' do
          @builder.series_options[:color_class] = 'red'

          assert_dom_equal <<~HTML, render(@builder, &:symbol)
            <span class="series-symbol red">●</span>
          HTML
        end

        test 'renders symbol with custom symbol' do
          @builder.series_options[:symbol] = '★'

          assert_dom_equal <<~HTML, render(@builder, &:symbol)
            <span class="series-symbol blue">★</span>
          HTML
        end
      end
    end
  end
end
