# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Axes
      class TickElement < Element
        attribute :value
        attribute :position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_axis, :'rcharts/symbol'
        attribute :inline_axis_index, :integer, default: 0

        private

        def tags(&block)
          tag.svg class: 'axis-tick', x:, y: do
            tag.text class: 'axis-tick-text', data: { inline_axis:, inline_axis_index: } do
              block&.call(value) || value
            end
          end
        end

        def x
          case inline_axis
          when :x then position
          else inline_axis_index.zero? ? Percentage::MAX : Percentage::MIN
          end
        end

        def y
          case inline_axis
          when :x then Percentage::MIN
          else Percentage::MAX - position
          end
        end
      end
    end
  end
end
