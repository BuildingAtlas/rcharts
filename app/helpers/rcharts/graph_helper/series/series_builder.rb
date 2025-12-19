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
        def scatter(**)
          scatter_tag(**)
        end

        private

        delegate :stacked?, to: :block_axis, private: true
        delegate :horizontal?, to: :inline_axis, private: true

        alias horizontal horizontal?

        def path_tag(**)
          render PathElement.new(series: current_points, horizontal:, series_options:, index:, id_hash:, **)
        end

        def area_tag(sign: nil, **)
          render AreaElement.new(series: current_points(signed: sign),
                                 previous_series: previous_points(signed: sign), mask_series: mask_points,
                                 block_position:, horizontal:, series_options:, index:, id_hash:, **)
        end

        def scatter_tag(**)
          render ScatterElement.new(series: current_points, horizontal:, series_options:, index:, id_hash:, **)
        end

        def current_points(signed: nil)
          series(signed:).to_h do |key, value|
            [inline_axis.position_for(key), value.try { block_axis.position_for(it) }]
          end
        end

        def previous_points(signed: nil)
          return [] if series(signed:) == previous_series(signed:)

          previous_series(signed:).to_h do |key, value|
            [inline_axis.position_for(key), block_axis.position_for(value)]
          end
        end

        def series(signed: nil)
          composition.signed(signed)
                     .then { stacked? ? it.stacked : it }
                     .then { it[name] }
        end

        def previous_series(signed: nil)
          composition.signed(signed)
                     .then { stacked? ? it.stacked(exclude_current: true) : it }
                     .then { it[name] }
        end

        def mask_points
          composition.sum_complete.to_h do |key, value|
            [inline_axis.position_for(key), value.try { block_axis.position_for(it) }]
          end
        end

        def block_position
          block_axis.position_for([block_axis.adjusted_minimum, 0].max)
        end

        def block_axis
          composition.axes.continuous
        end

        def inline_axis
          composition.axes.discrete
        end
      end
    end
  end
end
