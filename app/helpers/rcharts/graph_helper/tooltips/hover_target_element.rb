# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class HoverTargetElement < Element
        attribute :inline_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_size, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_axis, :'rcharts/symbol'

        private

        def tags(&)
          tag.rect x:, y:, width:, height:, class: 'tooltip-hover-target'
        end

        def x
          inline_position - (inline_size / 2) if horizontal_inline_axis?
        end

        def y
          inline_position - (inline_size / 2) unless horizontal_inline_axis?
        end

        def width
          horizontal_inline_axis? ? inline_size : Percentage::MAX
        end

        def height
          horizontal_inline_axis? ? Percentage::MAX : inline_size
        end

        def horizontal_inline_axis?
          inline_axis == :x
        end
      end
    end
  end
end
