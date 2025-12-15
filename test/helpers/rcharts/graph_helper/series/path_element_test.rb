# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class PathElementTest < ActionView::TestCase
        setup do
          @element = PathElement.new
        end

        test 'renders element' do
          assert_dom_equal render_erb(<<~HTML, element_id: @element.id_hash), render(@element)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= element_id %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-path blue"
                    mask="url(#series-mask-<%= element_id %>)" />
            </svg>
          HTML
        end

        test 'renders element with series options' do
          @element.series_options = { color_class: 'lime' }

          render @element

          assert_select '.series-path.lime'
        end

        test 'renders element with series' do
          @element.series = { 10 => 15.3, 20 => 25.6, 30 => 35.9 }

          render @element

          assert_select '.series-path' do |elements|
            elements.each do |element|
              assert_match Regexp.new('M [0-9,.]+ L [0-9,.]+'), element['d']
            end
          end
        end

        test 'renders element with index' do
          @element.index = 1

          render @element

          assert_select '.series-path.red'
        end

        test 'renders element with smoothing' do
          @element.assign_attributes(smoothing: 1.2, series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 })

          render @element

          assert_select '.series-path' do |elements|
            elements.each do |element|
              assert_match Regexp.new('M [0-9,.]+ C [0-9,.]+'), element['d']
            end
          end
        end

        test 'renders element on horizontal axis' do
          @element.assign_attributes(horizontal: true, series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 })

          render @element

          assert_select 'rect[x="10"]'
        end

        test 'renders element with ID hash' do
          @element.id_hash = '1234567890'

          render @element

          assert_select '#series-mask-1234567890'
        end
      end
    end
  end
end
