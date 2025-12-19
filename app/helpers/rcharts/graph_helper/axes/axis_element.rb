# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Axes
      class AxisElement < Element
        include Styles

        attribute :name
        attribute :index, :integer, default: 0
        attribute :ticks, default: -> { {} }
        attribute :label
        attribute :horizontal, :boolean, default: false
        attribute :character_scaling_factor, :float, default: 1.0

        private

        attr_accessor :max_label_characters

        alias horizontal? horizontal

        def tags(&block)
          with_max_label_characters_from block do
            style_tag + container_tag(&block)
          end
        end

        def container_tag(&)
          tag.div class: 'axis', data: { name:, index: } do
            svg_tag(&) + label_tag
          end
        end

        def svg_tag(&)
          tag.svg class: 'axis-ticks', width: max_column_characters.try { "#{it * character_scaling_factor}ch" },
                  data: { axis: axis_id } do
            ticks.each do |position, value|
              concat tick_tag_for(position, value, &)
            end
          end
        end

        def label_tag
          return ''.html_safe unless label

          render LabelElement.new(label:, horizontal: horizontal?)
        end

        def tick_tag_for(position, value, &)
          render TickElement.new(inline_axis: name, inline_axis_index: index,
                                 value:, position:), &
        end

        def style_tag
          tag.style rendered_css
        end

        def max_column_characters
          return if horizontal?

          max_label_characters
        end

        def min_row_characters
          max_label_characters.to_i * tick_count
        end

        def with_max_label_characters_from(proc, &block)
          self.max_label_characters = ticks.values
                                           .collect { |value| capture_length { proc&.call(value) || value.to_s } }
                                           .max
          block&.call.tap { self.max_label_characters = nil }
        end

        def capture_length(&)
          strip_tags(capture(&)).squish.length
        end

        def axis_id
          hash.abs
        end

        def tick_count
          ticks.count + 1
        end
      end
    end
  end
end
