# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class SeriesBuilderTest < ActionView::TestCase
        setup do
          @composition = Graph::Composition.new({ 2000 => { predicted: 42, actual: 43 },
                                                  2001 => { predicted: 44, actual: 45 },
                                                  2002 => { predicted: 46, actual: 47 } })
          @builder = SeriesBuilder.new
        end

        test 'renders line series' do
          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:line)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-path blue"
               mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
          HTML
        end

        test 'renders line series with options' do
          @builder.assign_attributes(name: :predicted, composition: @composition, index: 0,
                                     series_options: { color_class: 'red' })

          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:line)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
                <rect x="0.0" y="-50%" width="100.0" height="200%" fill="white" />
              </mask>
              <path d="M 0.0,100.0 L 0.0,100.0 L 50.0,60.0 L 100.0,20.0"
                    style="d:path(&quot;M 0.0,100.0 L 0.0,100.0 L 50.0,60.0 L 100.0,20.0&quot;)"
                    class="series-path red" mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
          HTML
        end

        test 'renders area series' do
          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:area)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-shape blue"
                    mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-shape blue"
                    mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
          HTML
        end

        test 'renders area series with options' do
          @builder.assign_attributes(name: :predicted, composition: @composition, index: 0,
                                     series_options: { color_class: 'red' })

          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:area)
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
                <rect x="0.0" y="-50%" width="100.0" height="200%" fill="white" />
              </mask>
              <path d="M 0.0,100.0 L 0.0,100.0 L 0.0,100.0 L 50.0,60.0 L 100.0,20.0 L 100.0,100.0"
                    style="d:path(&quot;M 0.0,100.0 L 0.0,100.0 L 0.0,100.0 L 50.0,60.0 L 100.0,20.0 L 100.0,100.0&quot;)"
                    class="series-shape red" mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
            <svg class="series" height="100%" width="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
              <mask id="series-mask-<%= id_hash %>" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse">
                <rect x="-50%" y="-50%" width="200%" height="200%" fill="black" />
                <rect x="0.0" y="-50%" width="100.0" height="200%" fill="white" />
              </mask>
              <path d="" style="d:path(&quot;&quot;)" class="series-shape red" mask="url(#series-mask-<%= id_hash %>)" />
            </svg>
          HTML
        end

        test 'renders scatter series' do
          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:scatter)
            <g>
              <defs>
                <symbol id="<%= id_hash %>-marker" x="-6.0" y="-6.0" width="12.0" height="12.0">
                  <line x1="2.0" x2="10.0" y1="2.0" y2="10.0" class="series-path" />
                  <line x1="10.0" x2="2.0" y1="2.0" y2="10.0" class="series-path" />
                </symbol>
              </defs>
              <g></g>
            </g>
          HTML
        end

        test 'renders scatter series with options' do
          @builder.assign_attributes(name: :predicted, composition: @composition, index: 0,
                                     series_options: { color_class: 'red' })

          assert_dom_equal render_erb(<<~HTML, id_hash: @builder.id_hash), render(@builder, &:scatter), html_version: :html4
            <g>
              <defs>
                <symbol id="<%= id_hash %>-marker" x="-6.0" y="-6.0" width="12.0" height="12.0">
                  <line x1="2.0" x2="10.0" y1="2.0" y2="10.0" class="series-path" />
                  <line x1="10.0" x2="2.0" y1="2.0" y2="10.0" class="series-path" />
                </symbol>
              </defs>
              <g>
                <use href="#<%= id_hash %>-marker" x="0.0%" y="100.0%" class="series-path red"></use>
                <use href="#<%= id_hash %>-marker" x="50.0%" y="60.0%" class="series-path red"></use>
                <use href="#<%= id_hash %>-marker" x="100.0%" y="20.0%" class="series-path red"></use>
              </g>
            </g>
          HTML
        end
      end
    end
  end
end
