# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Categories
      # = Category Builder
      class CategoryBuilder < ElementBuilder
        ##
        # :attr_accessor:
        attribute :name

        ##
        # :attr_accessor: index
        attribute :index, :integer, default: 0

        attribute :category, default: -> { {} }
        attribute :values_count, :integer, default: 1
        attribute :layout_axes, default: -> { Graph::Axes.new }
        attribute :series_options, default: -> { {} }

        # Shortcut to render a bar for every series. Useful when you don't need to differentiate between different
        # series. Arguments and options are passed to #series, see there for more details.
        def bar(*, **)
          series(*, **, &:bar)
        end

        # Renders one or more series present in the data. For each series yields a BarBuilder which
        # contains the series:
        #   <%= graph_for @annual_sales do |graph| %>
        #     <%= graph.category do |category| %>
        #       <%= category.series do |series| %>
        #         <%= series.bar %>
        #       <% end %>
        #     <% end %>
        #   <% end %>
        # The default is to iterate over all series, but you can specify a subset by passing the series names as
        # arguments.
        #
        # ==== Options
        # [<tt>:axis</tt>] The axis for the series. Defaults to the first continuous axis.
        # [<tt>:inline_axis</tt>] The axis for the categories. Defaults to the first discrete axis.
        def series(*names, axis: nil, inline_axis: nil, **, &)
          bars_tag(axis: inline_axis) do
            filtered_series(*names).each_with_index do |(name, value), index|
              concat bar_for(name, value, index, filtered_series(*names)&.count, axis:, **, &)
            end
          end
        end

        private

        def bars_tag(axis: nil, **, &)
          resolve_axis :discrete, axis do |discrete_axis|
            render BarsElement.new(index:, values_count:, inline_position: discrete_axis.position_at(index),
                                   horizontal: discrete_axis.horizontal?, **), &
          end
        end

        def bar_for(name, value, index, series_count, axis: nil, **, &) # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength
          resolve_axis :continuous, axis do |continuous_axis|
            render BarBuilder.new(name:, inline_index: (continuous_axis.stacked? ? 0 : index),
                                  series_index: category.keys.index(name),
                                  inline_size: inline_size_for(continuous_axis, series_count),
                                  series_options: series_options.fetch(name, {}),
                                  horizontal: continuous_axis.horizontal?,
                                  block_size: continuous_axis.length_between(0, value.to_f),
                                  block_position: block_position_for(continuous_axis, name, value),
                                  **),
                   &
          end
        end

        def inline_size_for(continuous_axis, series_count = nil)
          Percentage::MAX / (continuous_axis.stacked? ? 1 : series_count || category.keys.count)
        end

        def block_position_for(continuous_axis, name, value)
          continuous_axis.position_for(adjusted_value_for(continuous_axis, name, value))
        end

        def adjusted_value_for(continuous_axis, name, value)
          previous_value_for(name, continuous_axis).to_f + value_offset_for(continuous_axis, value)
        end

        def value_offset_for(axis, value)
          (axis.horizontal? && value.to_f.positive?) || (!axis.horizontal? && value.to_f.negative?) ? 0 : value.to_f
        end

        def previous_value_for(key, continuous_axis)
          index_of(key).then do |index|
            return 0 if !continuous_axis.stacked? || index.zero?

            filtered_series.values
                           .slice(0...index)
                           .compact
                           .filter(&(filtered_series.values[index].to_f.positive? ? :positive? : :negative?))
                           .sum
          end
        end

        def index_of(key)
          filtered_series.keys.index(key)
        end

        def filtered_series(*names)
          category.reject { names.presence&.exclude?(it) }
        end

        def resolve_axis(type, name = nil, &)
          (name ? layout_axes.fetch(*name) : layout_axes.public_send(type)).then(&)
        end
      end
    end
  end
end
