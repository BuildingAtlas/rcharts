# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class MarkerElement < Element # :nodoc:
        attribute :inline_position, :'rcharts/percentage'
        attribute :inline_axis, :'rcharts/symbol'

        private

        def tags(&)
          tag.line x1:, x2:, y1:, y2:, class: 'tooltip-marker'
        end

        def x1
          horizontal_inline_axis? ? inline_position : Percentage::MIN
        end

        def x2
          horizontal_inline_axis? ? inline_position : Percentage::MAX
        end

        def y1
          horizontal_inline_axis? ? Percentage::MIN : inline_position
        end

        def y2
          horizontal_inline_axis? ? Percentage::MAX : inline_position
        end

        def horizontal_inline_axis?
          inline_axis == :x
        end
      end
    end
  end
end
