# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        module Positioning
          extend ActiveSupport::Concern
          include Ticks

          included do
            def ticks
              return {} unless values.any?

              @ticks ||= tick_count.succ.times.to_h { [position_at(it), value_at(it)] }
            end

            def position_at(index)
              return if index > tick_count

              ((index * (100.0 / (tick_count.nonzero? || 1))) + tick_offset.to_f) * (100 / (100 + (2 * tick_offset.to_f)))
            end

            def value_at(index)
              return if index > tick_count || index.negative? || values.empty?
              return values.dig(index, 0) if discrete || values.dig(0, 0).is_a?(String)

              adjusted_minimum + (index * tick_interval)
            end

            def length_between(min, max)
              return position_for(0 - max) - position_for(0 - min) if max.negative?

              (position_for(max) - position_for(min))
            end

            def position_for(value)
              return position_at(keys.index(value)) if discrete == :categorical
              return 0 if adjusted_maximum == adjusted_minimum

              ((value.to_f - adjusted_minimum.to_f) / (adjusted_maximum - adjusted_minimum)) * 100
            end
          end
        end
      end
    end
  end
end
