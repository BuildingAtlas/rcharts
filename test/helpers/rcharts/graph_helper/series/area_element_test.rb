# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class AreaElementTest < ActionView::TestCase
        setup do
          @element = AreaElement.new
        end

        test 'renders element' do
          assert_dom_equal render_erb(<<~HTML, id_hash: @element.id_hash), render(@element)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-shape blue" mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
          HTML
        end

        test 'renders element with previous series' do
          @element.assign_attributes(previous_series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 },
                                     series: { 10 => 12.3, 20 => 22.6, 30 => 32.9 })

          render @element

          assert_select '.series-shape' do |elements|
            elements.each do |element|
              assert_match Regexp.new('M [0-9,.]+ L [0-9,.]+'), element['d']
              assert_match Regexp.new('L 30,100.0 L [0-9]+'), element['d']
            end
          end
        end

        test 'renders element with mask series' do
          @element.assign_attributes(mask_series: { 10 => 15.3, 20 => 25.6, 30 => nil })

          render @element

          assert_select "#series-mask-#{@element.id_hash}" do
            assert_select 'rect', count: 2
            assert_select 'rect[height="200%"]', count: 1
          end
        end

        test 'renders element with block position' do
          @element.assign_attributes(block_position: 50,
                                     previous_series: { 10 => 15.3, 20 => 25.6, 30 => 35.9 },
                                     series: { 10 => 12.3, 20 => 22.6, 30 => 32.9 })

          render @element

          assert_select '.series-shape' do |elements|
            elements.each do |element|
              assert_match Regexp.new('L 30,50.0 L [0-9]+'), element['d']
            end
          end
        end
      end
    end
  end
end
