# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      # = \Series Builder
      class SeriesBuilder < ElementBuilder
        ##
        # :attr_accessor:
        attribute :name

        ##
        # :attr_accessor: index
        attribute :index, :integer, default: 0

        attribute :composition, default: -> { Graph::Composition.new }
        attribute :series_options, default: -> { {} }
        attribute :id_hash, :string, default: -> { SecureRandom.hex(4) }

        # Renders the series as a line plot. Passes through <tt>:data</tt>, and <tt>:aria</tt>,
        # and <tt>:class</tt> options to the tag builder.
        #   <%= graph_for @sales do |graph| %>
        #     <%= graph.series do |series| %>
        #       <%= series.line smooth: 0.12 %>
        #     <% end %>
        #   <% end %>
        #
        # ==== Options
        # [<tt>:smooth</tt>] Smoothing factor for the line.
        # [<tt>:axis</tt>] The axis for the series. Defaults to the first continuous axis.
        # [<tt>:inline_axis</tt>] The axis for the categories. Defaults to the first discrete axis.
        def line(**)
          path_tag(**)
        end

        # Renders the series as an area plot. Passes through <tt>:data</tt>, and <tt>:aria</tt>,
        # and <tt>:class</tt> options to the tag builder.
        #   <%= graph_for @sales do |graph| %>
        #     <%= graph.series do |series| %>
        #       <%= series.area smooth: 0.12 %>
        #     <% end %>
        #   <% end %>
        #
        # ==== Options
        # [<tt>:smooth</tt>] Smoothing factor for the area.
        # [<tt>:axis</tt>] The axis for the series. Defaults to the first continuous axis.
        # [<tt>:inline_axis</tt>] The axis for the categories. Defaults to the first discrete axis.
        def area(**)
          area_tag(sign: :positive, **) + area_tag(sign: :negative, **)
        end

        # Renders the series as a scatter plot. Passes through <tt>:data</tt>, and <tt>:aria</tt>,
        # and <tt>:class</tt> options to the tag builder.
        #   <%= graph_for @sales do |graph| %>
        #     <%= graph.series do |series| %>
        #       <%= series.scatter %>
        #     <% end %>
        #   <% end %>
        # ==== Options
        # [<tt>:marker_size</tt>] Size of the markers. Defaults to <tt>10.0</tt>.
        # [<tt>:marker_margin</tt>] Margin around the marker symbol. Defaults to <tt>2.0</tt>.
        # [<tt>:marker_id</tt>] ID of a custom marker symbol (a <tt><symbol></tt> element).
        # [<tt>:axis</tt>] The axis for the series. Defaults to the first continuous axis.
        # [<tt>:inline_axis</tt>] The axis for the categories. Defaults to the first discrete axis.
        def scatter(**)
          scatter_tag(**)
        end

        private

        def path_tag(axis: nil, inline_axis: nil, **)
          resolve_axis :continuous, axis do |continuous_axis|
            resolve_axis :discrete, inline_axis do |discrete_axis|
              render PathElement.new(series: current_points(discrete_axis, continuous_axis),
                                     horizontal: discrete_axis.horizontal?, series_options:, index:, id_hash:, **)
            end
          end
        end

        def area_tag(sign: nil, axis: nil, inline_axis: nil, **)
          resolve_axis :continuous, axis do |continuous_axis|
            resolve_axis :discrete, inline_axis do |discrete_axis|
              render AreaElement.new(series: current_points(discrete_axis, continuous_axis, signed: sign),
                                     previous_series: previous_points(discrete_axis, continuous_axis, signed: sign),
                                     mask_series: mask_points(discrete_axis, continuous_axis),
                                     block_position: block_position(continuous_axis),
                                     horizontal: discrete_axis.horizontal?,
                                     series_options:, index:, id_hash:, **)
            end
          end
        end

        def scatter_tag(axis: nil, inline_axis: nil, **)
          resolve_axis :continuous, axis do |continuous_axis|
            resolve_axis :discrete, inline_axis do |discrete_axis|
              render ScatterElement.new(series: current_points(discrete_axis, continuous_axis),
                                        horizontal: discrete_axis.horizontal?,
                                        series_options:, index:, id_hash:, **)
            end
          end
        end

        def current_points(inline_axis, block_axis, signed: nil)
          series(block_axis, signed:).to_h do |key, value|
            [inline_axis.position_for(key), value.try { block_axis.position_for(it) }]
          end
        end

        def previous_points(inline_axis, block_axis, signed: nil)
          return [] if series(block_axis, signed:) == previous_series(block_axis, signed:)

          previous_series(block_axis, signed:).to_h do |key, value|
            [inline_axis.position_for(key), block_axis.position_for(value)]
          end
        end

        def series(block_axis, signed: nil)
          composition.signed(signed)
                     .then { block_axis.stacked? ? it.stacked : it }
                     .then { it[name] }
        end

        def previous_series(block_axis, signed: nil)
          composition.signed(signed)
                     .then { block_axis.stacked? ? it.stacked(exclude_current: true) : it }
                     .then { it[name] }
        end

        def mask_points(inline_axis, block_axis)
          composition.sum_complete.to_h do |key, value|
            [inline_axis.position_for(key), value.try { block_axis.position_for(it) }]
          end
        end

        def block_position(block_axis)
          block_axis.position_for([block_axis.adjusted_minimum, 0].max)
        end

        def resolve_axis(type, name = nil, &)
          (name ? composition.axes.fetch(*name) : composition.axes.public_send(type)).then(&)
        end
      end
    end
  end
end
