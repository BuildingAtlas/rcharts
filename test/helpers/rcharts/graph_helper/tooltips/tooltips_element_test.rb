# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipsElementTest < ActionView::TestCase
        setup do
          @composition = Graph::Composition.new({ 2000 => { predicted: 42, actual: 43 }, 2001 => { predicted: 44, actual: 45 } })
          @element = TooltipsElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <svg class="tooltips" width="100%" xmlns="http://www.w3.org/2000/svg"></svg>
          HTML
        end

        test 'renders element with composition' do
          @element.composition = @composition

          render @element do |category|
            category.series(&:dot)
          end

          assert_select '.tooltip', count: 2
        end

        test 'renders element with series options' do
          @element.assign_attributes(series_options: { predicted: { color_class: 'lime' } },
                                     composition: @composition)

          render @element do |category|
            category.series(&:dot)
          end

          assert_select '.lime', count: 2
        end
      end
    end
  end
end
