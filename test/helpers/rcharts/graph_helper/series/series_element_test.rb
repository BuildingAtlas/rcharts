# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class SeriesElementTest < ActionView::TestCase
        setup do
          @composition = Graph::Composition.new({ 2000 => { predicted: 42, actual: 43 },
                                                  2001 => { predicted: 44, actual: 45 },
                                                  2002 => { predicted: 46, actual: 47 } })
          @element = SeriesElement.new
        end

        test 'renders element' do
          assert_dom_equal <<~HTML, render(@element)
            <svg class="series-container"></svg>
          HTML
        end

        test 'renders element with composition' do
          @element.assign_attributes(composition: @composition, series_options: { predicted: {}, actual: {} })

          render @element, &:line

          assert_select '.series-path', count: 2
        end

        test 'renders element with series names' do
          @element.assign_attributes(composition: @composition,
                                     series_options: { predicted: {}, actual: {} },
                                     series_names: %i[predicted])

          render @element, &:line

          assert_select '.series-path', count: 1
        end
      end
    end
  end
end
