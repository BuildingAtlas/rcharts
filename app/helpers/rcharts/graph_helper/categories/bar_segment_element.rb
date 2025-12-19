# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Categories
      class BarSegmentElement < Element # :nodoc:
        attribute :horizontal, :boolean, default: false
        attribute :inline_size, :'rcharts/percentage', default: Percentage::MAX
        attribute :block_size, :'rcharts/percentage', default: Percentage::MAX
        attribute :block_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_index, :integer, default: 0
        attribute :series_index, :integer, default: 0
        attribute :series_options, default: -> { {} }

        private

        alias horizontal? horizontal

        def tags
          tag.rect x:, y:, height:, width:, class: ['series-shape', class_names, color_class], data:, aria:
        end

        def x
          horizontal? ? block_position : inline_position
        end

        def y
          horizontal? ? inline_position : Percentage::MAX - block_position
        end

        def height
          horizontal? ? inline_size : block_size
        end

        def width
          horizontal? ? block_size : inline_size
        end

        def inline_position
          inline_size * inline_index
        end

        def color_class
          series_options.fetch(:color_class, RCharts.color_class_for(series_index))
        end
      end
    end
  end
end
