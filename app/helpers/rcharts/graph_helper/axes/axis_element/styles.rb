# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Axes
      class AxisElement
        module Styles
          extend ActiveSupport::Concern

          ROTATION_CSS = <<~CSS
            @container (inline-size < <%= min_row_characters %>) {
              .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick-text {
                  dominant-baseline: middle;
                  rotate: -45deg;
                  text-anchor: end;
                }
                .axis-ticks[data-axis="<%= axis_id %>"] {
                  height: calc(<%= max_label_characters %> * sin(45deg));
                }
              }

              @container (inline-size < calc(<%= min_row_characters %> * 0.9)) {
              .rcharts-chart .axis[data-name="x"] {
                  .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick-text {
                    rotate: -90deg;
                  }
                  .axis-ticks[data-axis="<%= axis_id %>"] {
                    height: <%= max_label_characters %>;
                  }
                }
              }
            }
          CSS

          HIDING_CSS = <<~CSS
            @container (inline-size < calc(<%= tick_count %> * 1.1)) {
              .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick:nth-child(even) .axis-tick-text {
                  opacity: 0;
                }
              }
            }

            @container (inline-size < calc(<%= tick_count %> * 0.6)) {
              .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick:nth-child(4n + 3) .axis-tick-text {
                  opacity: 0;
                }
              }
            }
          CSS

          included do
            private

            def rendered_css
              return unless horizontal?

              ERB.new(ROTATION_CSS + HIDING_CSS)
                 .result_with_hash(min_row_characters: "#{min_row_characters}ch",
                                   max_label_characters: "#{max_label_characters}ch",
                                   tick_count: "#{tick_count}lh",
                                   axis_id:)
                 .html_safe # rubocop:disable Rails/OutputSafety
            end
          end
        end
      end
    end
  end
end
