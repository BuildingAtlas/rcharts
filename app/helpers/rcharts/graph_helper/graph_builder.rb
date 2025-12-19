# frozen_string_literal: true

module RCharts
  module GraphHelper
    # = \GraphBuilder
    #
    # Base class for drawing responsive pure-SVG graphs.
    class GraphBuilder < ElementBuilder
      attribute :graphable, default: -> { {} }
      attribute :gutter, :float, default: 10.0
      attribute :axis_options, default: -> { {} }
      attribute :series_options, default: -> { {} }

      # Renders a series for a set of points.
      def series(names = nil, **, &)
        tag.svg class: 'series-container' do
          selected_series(excluding: names).each do |key|
            concat render Series::SeriesBuilder.new(name: key, index: series_options_with_defaults.keys.index(key),
                                                    series_options: series_options_with_defaults.fetch(key, {}),
                                                    composition:), &
          end
        end
      end

      # Renders a category.
      def categories(**, &)
        tag.svg class: 'category-container' do
          composition.values.each_with_index do |(name, category), index|
            concat render Categories::CategoryBuilder.new(layout_axes: composition.axes, name:, category:, index:,
                                                          values_count: composition.values.count, series_options:), &
          end
        end
      end

      # Renders an axis for a set of points.
      def axis(*name, **, &)
        axes.fetch(*name).then do |axis|
          render Axes::AxisElement.new(name: axis.name, index: axis.index, ticks: axis.ticks, horizontal: axis.horizontal?, **), &
        end
      end

      # Renders rules for an axis.
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

      # Renders the legend.
      def legend(placement: 'bottom', **, &)
        tag.ul class: 'legend', data: { placement: } do
          series_options_with_defaults.each_key.with_index do |key, index|
            concat legend_item_tag_for(key, index, **, &)
          end
        end
      end

      # Renders the tooltips.
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
