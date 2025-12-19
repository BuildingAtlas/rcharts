# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        module Ticks # :nodoc:
          INTERVAL_FACTORS = [1, 2, 5, 10, 30].freeze
          INTERVAL_BASES = ActiveSupport::Duration::PARTS_IN_SECONDS
          ALL_INTERVALS = INTERVAL_BASES.values.flat_map { |base| INTERVAL_FACTORS.collect { base * it } }

          extend ActiveSupport::Concern

          included do
            def tick_count
              return values_count.pred if discrete?

              ((maximum - adjusted_minimum) / tick_interval).ceil
            end

            def adjusted_minimum
              @adjusted_minimum ||= Caster.new(minimum).casting { (it / tick_interval).floor * tick_interval }
            end

            private

            def interval
              ((maximum + adjustment_for_empty_interval) - (minimum - adjustment_for_empty_interval)) / 10.0
            end

            def adjustment_for_empty_interval
              return 0 if minimum != maximum

              (maximum.nil? || maximum.zero? ? 1.0 : (maximum.abs * 0.1)) * 0.5
            end

            def tick_interval
              return 0 if interval <= 0
              return ALL_INTERVALS.min_by { (it - interval).abs } if minimum.is_a?(Time)

              tick_base * case (interval / tick_base)
                          when ..1 then 1
                          when 1..2 then 2
                          when 2..2.5 then 2.5
                          when 2.5..5 then 5
                          else 10
                          end
            end

            def tick_base
              10**BigDecimal(Math.log10(interval).floor)
            end

            def tick_offset
              (100.0 / values_count) / 2 if categorical?
            end

            def adjusted_maximum
              @adjusted_maximum ||= adjusted_minimum + (tick_count * tick_interval)
            end
          end
        end
      end
    end
  end
end
