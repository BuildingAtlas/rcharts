# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class ForeignObjectElement < Element
        attribute :inline_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_axis, :'rcharts/symbol'
        attribute :index, :integer, default: 0
        attribute :values_count, :integer, default: 0

        private

        def tags(&)
          tag.foreignObject width:, height:, x:, y:, class: 'tooltip-object' do
            container_tag(&)
          end
        end

        def container_tag(&)
          tag.div class: ['tooltip-container', { 'anchor-end' => anchor_bottom?, 'justify-end' => anchor_right? }], &
        end

        def x
          return unless horizontal_inline_axis?

          anchor_right? ? Percentage::MIN : inline_position
        end

        def y
          return if horizontal_inline_axis?

          anchor_bottom? ? Percentage::MIN : inline_position
        end

        def width
          return Percentage::MAX unless horizontal_inline_axis?

          anchor_left? ? Percentage::MAX - inline_position : inline_position
        end

        def height
          return Percentage::MAX if horizontal_inline_axis?

          anchor_top? ? Percentage::MAX - inline_position : inline_position
        end

        def anchor_right?
          return true unless horizontal_inline_axis?

          first_half? == false
        end

        def anchor_left?
          return false unless horizontal_inline_axis?

          first_half?
        end

        def anchor_top?
          return false if horizontal_inline_axis?

          first_half?
        end

        def anchor_bottom?
          return false if horizontal_inline_axis?

          first_half? == false
        end

        def horizontal_inline_axis?
          inline_axis == :x
        end

        def first_half?
          return if values_count.zero? # rubocop:disable Style/ReturnNilInPredicateMethodDefinition

          index < values_count / 2.0
        end
      end
    end
  end
end
