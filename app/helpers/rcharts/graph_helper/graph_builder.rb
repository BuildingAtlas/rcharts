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
        render Series::SeriesElement.new(composition:, series_names: names, series_options: series_options_with_defaults), &
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
      def legend(**, &)
        render Legend::LegendElement.new(series_options: series_options_with_defaults, **), &
      end

      # Renders the tooltips.
      def tooltips(**, &)
        render Tooltips::TooltipsElement.new(composition:, series_options: series_options_with_defaults), &
      end

      private

      delegate :axes, to: :composition, private: true

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
    end
  end
end
