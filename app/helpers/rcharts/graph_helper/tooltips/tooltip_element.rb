# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipElement < Element # :nodoc:
        attribute :inline_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_size, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_axis, :'rcharts/symbol'
        attribute :index, :integer, default: 0
        attribute :values_count, :integer, default: 0

        def tags(&)
          tag.g class: 'tooltip' do
            hover_target_tag + marker_tag + tooltip_tag(&)
          end
        end

        private

        def tooltip_tag(&)
          foreign_object_tag do
            content_tag(&)
          end
        end

        def foreign_object_tag(&)
          render ForeignObjectElement.new(inline_position:, inline_axis:, index:, values_count:), &
        end

        def content_tag(&)
          tag.div class: 'tooltip-content', &
        end

        def marker_tag
          render MarkerElement.new(inline_position:, inline_axis:)
        end

        def hover_target_tag
          render HoverTargetElement.new(inline_position:, inline_size:, inline_axis:)
        end
      end
    end
  end
end
