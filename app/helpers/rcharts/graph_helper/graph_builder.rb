# frozen_string_literal: true

module RCharts
  module GraphHelper
    # = \RCharts \Graph Builder
    #
    # A GraphBuilder object contains a hash of data and allows you to render the various parts of a graph using the
    # contained data. This is the object yielded when using GraphHelper#graph_for. For example:
    #   <%= graph_for @annual_sales do |graph| %>
    #     <%= graph.series do |series| %>
    #       <%= series.line %>
    #     <% end %>
    #   <% end %>
    # Here, the <tt>graph</tt> variable is a yielded GraphBuilder object. You can then render
    # a line chart from the annual sales data by calling #series to obtain a Series::SeriesBuilder which can iterate
    # over the series present in the data, and then calling Series::SeriesBuilder#line to render a line for the series
    # points.
    #
    # The GraphBuilder object allows rendering as many or few elements of the graph as necessary while still maintaining
    # coherence between them.
    #
    # Like form builders, you can subclass GraphBuilder to extend it with custom behaviour. Perhaps you want the legend
    # to be placed at the top by default, for example:
    #   class MyGraphBuilder < RCharts::GraphHelper::GraphBuilder
    #     def legend(**options, &)
    #       super(**options.merge(placement: :top, &)
    #     end
    #   end
    # Then you can use the new builder with GraphHelper#graph_for:
    #   <%= graph_for @annual_sales, builder: MyGraphBuilder do |graph| %>
    #     <%= graph.legend do |series| %>
    #       <%= series.dot %>
    #       <%= series.name %>
    #     <% end %>
    #   <% end %>
    class GraphBuilder < ElementBuilder
      ##
      # :attr_accessor:
      # data used to render the graph
      attribute :graphable, default: -> { {} }

      ##
      # :attr_accessor: gutter
      # value determining the length of short ticks
      attribute :gutter, :float, default: 10.0

      ##
      # :attr_accessor:
      # options for the layout axes
      attribute :axis_options, default: -> { {} }

      ##
      # :attr_accessor:
      # display options for each series
      attribute :series_options, default: -> { {} }

      # Renders one or more series present in the data. For each series yields a Series::SeriesBuilder which
      # contains the series:
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.series do |series| %>
      #       <%= series.line %>
      #     <% end %>
      #   <% end %>
      # The default is to iterate over all series, but you can specify a subset by passing the series names as
      # arguments.
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.series :baseline_prediction, :actual do |series| %>
      #       <%= series.line %>
      #     <% end %>
      #   <% end %>
      # Like GraphHelper#graph_for, you can use the <tt>:builder</tt> key to use a custom builder subclass,
      # <tt>:data</tt> to set data attributes, and <tt>:html</tt> to set other HTML attributes, while other options are
      # passed through to the builder.
      #
      # See Series::SeriesBuilder for more information.
      def series(*names, builder: Series::SeriesBuilder, data: {}, html: {}, **, &)
        tag.svg class: 'series-container', data:, **html do
          selected_series(only: names).each do |key|
            concat render builder.new(name: key, index: series_options_with_defaults.keys.index(key),
                                      series_options: series_options_with_defaults.fetch(key, {}),
                                      composition:,
                                      **), &
          end
        end
      end

      # Renders the categories present in the data. For each category yields a Categories::CategoryBuilder which
      # contains the category:
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.categories do |category| %>
      #       <%= category.bar %>
      #     <% end %>
      #   <% end %>
      # Like GraphHelper#graph_for, you can use the <tt>:builder</tt> key to use a custom builder subclass,
      # <tt>:data</tt> to set data attributes, and <tt>:html</tt> to set other HTML attributes, while other options are
      # passed through to the builder.
      #
      # See Categories::CategoryBuilder for more information.
      def categories(builder: Categories::CategoryBuilder, **, &)
        tag.svg class: 'category-container' do
          composition.values.each_with_index do |(name, category), index|
            concat render builder.new(layout_axes: composition.axes, name:, category:, index:,
                                      values_count: composition.values.count, series_options:), &
          end
        end
      end

      # Renders an axis for a set of points. The name is a key such as <tt>:x</tt> and optionally an index
      # that defaults to <tt>0</tt> if not provided. Yields the value of each tick on the axis so you can format it
      # appropriately.
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.axis :y, label: 'Primary Y axis' do |value| %>
      #       <%= number_with_delimiter value %>
      #     <% end %>
      #     <%= graph.axis :y, 1, label: 'Secondary Y axis' do |value| %>
      #       <%= number_with_delimiter value %>
      #     <% end %>
      #     <%= graph.axis :x, label: 'Primary X axis' do |value| %>
      #       <%= value %>
      #     <% end %>
      #     <%= graph.axis :x, 1, label: 'Secondary X axis' do |value| %>
      #       <%= value %>
      #     <% end %>
      #   <% end %>
      # ==== Options
      # [<tt>:label</tt>] The axis title
      # [<tt>:character_scaling_factor</tt>] The scaling factor for character width on a vertical axis. In this case,
      #                                      label width is calculated using the {width of zero in the current
      #                                      font}[https://meyerweb.com/eric/thoughts/2018/06/28/what-is-the-css-ch-unit/]
      #                                      multiplied by the maximum number of text characters for any label,
      #                                      so you can use this option to make adjustments according to your average
      #                                      character width ratio to zero. The default is <tt>1.0</tt>.
      # [<tt>:breakpoints</tt>] Related to the character scaling factor, these are used to determine the point at which
      #                         labels rotate or disappear. The defaults are: <tt>hiding: { even: 1.1, odd: 0.6 },
      #                         rotation: { half: 1.0, full: 0.9 }</tt>.
      def axis(*name, **, &)
        axes.fetch(*name).then do |axis|
          render Axes::AxisElement.new(name: axis.name, index: axis.index, ticks: axis.ticks, horizontal: axis.horizontal?, **), &
        end
      end

      # Renders rules for an axis. The name is a key such as <tt>:x</tt> and optionally an index that defaults to
      # <tt>0</tt> if not provided. Rules are both the full-length lines that span the entire width or height of
      # the plot, as well as the much shorter lines that mark each category (e.g. for a bar chart). Rules can also be
      # emphasized, e.g. for <tt>0</tt> in a chart which has both positive and negative values.
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.rules :y, emphasis: :zero? %>
      #     <%= graph.rules :x, short: true %>
      #     <%= graph.rules :x, 1, short: true %>
      #   <% end %>
      # ==== Options
      # [<tt>:short</tt>] Whether to render short rules (e.g. for bar chart categories)
      # [<tt>:emphasis</tt>] A callable predicate that determines whether a rule should be emphasized
      def rules(*name, short: false, emphasis: nil, **, &)
        tag.svg class: 'grid' do
          axes.fetch(*name).then do |axis|
            axis.ticks.each do |position, value|
              concat render RuleElement.new(short:, position:, value:, emphasis:, gutter:, axis_index: axis.index,
                                            horizontal_axis: axis.horizontal?), &
            end
          end
        end
      end

      # Renders the legend. For each series yields a Legend::EntryBuilder.
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.legend do |series| %>
      #       <%= series.dot %>
      #       <%= series.name %>
      #     <% end %>
      #   <% end %>
      #
      # See Legend::EntryBuilder for more information.
      #
      # ==== Options
      # [<tt>:placement</tt>] The placement of the legend (top, bottom, left, right). Defaults to <tt>'bottom'</tt>.
      def legend(placement: 'bottom', **, &)
        tag.ul class: 'legend', data: { placement: } do
          series_options_with_defaults.each_key.with_index do |key, index|
            concat legend_item_tag_for(key, index, **, &)
          end
        end
      end

      # Renders the tooltips. For each category yields a Tooltips::TooltipBuilder.
      #   <%= graph_for @annual_sales do |graph| %>
      #     <%= graph.tooltips do |category| %>
      #       <div class="tooltip-inner-content">
      #         <div class="tooltip-title">
      #           <%= category.name %>
      #         </div>
      #         <dl class="tooltip-items">
      #           <%= category.series class: 'tooltip-item' do |series| %>
      #             <dt>
      #               <%= series.dot %>
      #               <%= series.name %>
      #             </dt>
      #             <dd>
      #               <%= number_to_human series.value %>
      #             </dd>
      #           <% end %>
      #         </dl>
      #       </div>
      #     <% end %>
      #   <% end %>
      #
      # See Tooltips::TooltipBuilder for more information.
      def tooltips(**, &)
        tag.svg class: 'tooltips', width: '100%', xmlns: 'http://www.w3.org/2000/svg' do
          composition.values.each_key { concat tooltip_tag_for(it, &) }
        end
      end

      private

      delegate :axes, :values, to: :composition, private: true

      def series_options_with_defaults
        series_options.with_defaults(series_names.index_with { {} })
      end

      def composition
        @composition ||= Graph::Composition.new(graphable, axis_options)
      end

      def series_names
        return [] if graphable.empty?

        case graphable.values.first
        in Hash => graphable_hash then graphable_hash.keys
        in Array => graphable_array then (0...graphable_array.count).to_a
        else [nil]
        end
      end

      def selected_series(only: nil)
        series_options_with_defaults.keys.reject { only.presence&.exclude?(it) }
      end

      def legend_item_tag_for(key, index, **, &)
        tag.li class: 'legend-item' do
          render Legend::EntryBuilder.new(name: key, index:, series_options: series_options_with_defaults[key], **), &
        end
      end

      def tooltip_tag_for(key, &)
        render Tooltips::TooltipElement.new(inline_axis: inline_axis.name,
                                            inline_position: inline_axis.position_for(key) || Percentage::MIN,
                                            inline_size:,
                                            index: index_for(key),
                                            values_count: values.count) do
          render Tooltips::TooltipBuilder.new(series_options: series_options_with_defaults, values: values[key], name: key), &
        end
      end

      def inline_size
        Percentage::MAX / values.count
      end

      def index_for(key)
        composition.keys.index(key)
      end

      def inline_axis
        composition.axes.discrete
      end
    end
  end
end
