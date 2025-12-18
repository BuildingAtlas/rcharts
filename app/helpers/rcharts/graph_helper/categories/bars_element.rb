# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Categories
      class BarsElement < Element
        SPACING_FACTOR = 0.6

        attribute :index, :integer, default: 0
        attribute :values_count, :integer, default: 1
        attribute :inline_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :horizontal, :boolean, default: false

        private

        alias horizontal? horizontal

        def tags(&)
          tag.svg x:, y:, width:, height:, class: 'category', &
        end

        def x
          adjusted_inline_position if horizontal?
        end

        def y
          Percentage::MAX - adjusted_inline_position unless horizontal?
        end

        def height
          horizontal? ? Percentage::MAX : inline_size
        end

        def width
          horizontal? ? inline_size : Percentage::MAX
        end

        def inline_size
          (Percentage::MAX / values_count) * SPACING_FACTOR
        end

        def adjusted_inline_position
          inline_position + inline_adjustment
        end

        def inline_adjustment
          (inline_size / 2) * (horizontal? ? -1 : 1)
        end
      end
    end
  end
end
