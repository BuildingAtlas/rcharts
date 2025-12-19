# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Axes
      class AxisElement
        module Styles # :nodoc:
          DEFAULT_BREAKPOINTS = { hiding: { even: 1.1, odd: 0.6 }, rotation: { half: 1.0, full: 0.9 } }.freeze

          extend ActiveSupport::Concern

          ROTATION_CSS = <<~CSS
            @container (inline-size < calc(<%= min_row_characters %> * <%= half_rotation_breakpoint %>)) {
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
            }

            @container (inline-size < calc(<%= min_row_characters %> * <%= full_rotation_breakpoint %>)) {
            .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick-text {
                  rotate: -90deg;
                }
                .axis-ticks[data-axis="<%= axis_id %>"] {
                  height: <%= max_label_characters %>;
                }
              }
            }
          CSS

          HIDING_CSS = <<~CSS
            @container (inline-size < calc(<%= tick_count %> * <%= even_hiding_breakpoint %>)) {
              .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick:nth-child(even) .axis-tick-text {
                  opacity: 0;
                }
              }
            }

            @container (inline-size < calc(<%= tick_count %> * <%= odd_hiding_breakpoint %>)) {
              .rcharts-chart .axis[data-name="x"] {
                .axis-ticks[data-axis="<%= axis_id %>"] .axis-tick:nth-child(4n + 3) .axis-tick-text {
                  opacity: 0;
                }
              }
            }
          CSS

          included do
            attribute :breakpoints, default: -> { {} }

            private

            def rendered_css
              return unless horizontal?

              ERB.new(ROTATION_CSS + HIDING_CSS)
                 .result_with_hash(min_row_characters: "#{min_row_characters}ch",
                                   max_label_characters: "#{max_label_characters}ch",
                                   tick_count: "#{tick_count}lh",
                                   **breakpoints,
                                   axis_id:)
                 .html_safe # rubocop:disable Rails/OutputSafety
            end

            def breakpoints
              flatten_breakpoints(super.with_defaults(DEFAULT_BREAKPOINTS))
            end

            def flatten_breakpoints(hash)
              hash.each_with_object({}) do |(key, value), result|
                next result[key] = value unless value.is_a?(Hash)

                value.each do |nested_key, nested_value|
                  result[:"#{nested_key}_#{key}_breakpoint"] = nested_value
                end
              end
            end
          end
        end
      end
    end
  end
end
