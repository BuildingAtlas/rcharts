# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        module Positioning # :nodoc:
          extend ActiveSupport::Concern
          include Ticks

          included do
            def ticks
              return {} unless values.any?

              @ticks ||= tick_count.succ.times.to_h { [position_at(it), value_at(it)] }
            end

            def position_at(index)
              return if index > tick_count

              (tick_offset.to_f + raw_position_at(index))
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
              return values.flatten.index(value).try { position_at(it) } if discrete == :categorical
              return 0 if adjusted_maximum == adjusted_minimum

              downcasted_position_for(value)
            end

            private

            def raw_position_at(index)
              index * (100.0 / ((categorical? ? values_count.nonzero? : tick_count.nonzero?) || 1))
            end

            def downcasted_position_for(value)
              ((Caster.new(value).downcast.to_f - casted_adjusted_minimum) / casted_range) * 100
            end

            def casted_range
              casted_adjusted_maximum - casted_adjusted_minimum
            end

            def casted_adjusted_maximum
              Caster.new(adjusted_maximum).downcast
            end

            def casted_adjusted_minimum
              Caster.new(adjusted_minimum).downcast
            end
          end
        end
      end
    end
  end
end
