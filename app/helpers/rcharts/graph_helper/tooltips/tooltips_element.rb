# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipsElement < Element
        attribute :composition, default: -> { Graph::Composition.new }
        attribute :series_options, default: -> { {} }

        private

        delegate :values, to: :composition, private: true
        delegate :position_for, :categorical?, to: :inline_axis, private: true, allow_nil: true
        delegate :name, to: :inline_axis, prefix: true, private: true, allow_nil: true

        def tags(&)
          tag.svg class: 'tooltips', width: '100%', xmlns: 'http://www.w3.org/2000/svg' do
            values.each_key { concat tooltip_tag(it, &) }
          end
        end

        def tooltip_tag(key, &)
          render TooltipElement.new(inline_axis: inline_axis_name,
                                    inline_position: position_for(key) || Percentage::MIN,
                                    inline_size:,
                                    index: index_for(key),
                                    values_count:) do
            render TooltipBuilder.new(series_options:, values: values[key], name: key), &
          end
        end

        def inline_size
          Percentage::MAX / values_count
        end

        def values_count
          values.count
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
end
