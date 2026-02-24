# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        module Ticks # :nodoc:
          DECIMAL_INTERVALS = [1, 2, 2.5, 5, 10].freeze
          TEMPORAL_INTERVALS = [1.second, 2.seconds, 5.seconds, 10.seconds, 15.seconds, 30.seconds,
                                1.minute, 2.minutes, 5.minutes, 10.minutes, 15.minutes, 30.minutes,
                                1.hour, 2.hours, 3.hours, 6.hours, 12.hours,
                                1.day, 2.days,
                                1.week, 2.weeks,
                                1.month, 2.months, 3.months, 6.months,
                                1.year, 2.years, 5.years, 10.years, 20.years, 50.years, 100.years].freeze
          TARGET_TICK_COUNT = 10.0

          extend ActiveSupport::Concern

          included do
            def tick_count
              return values_count.pred if categorical?
              return values_count if discrete?

              (range / tick_interval.to_f).ceil
            end

            def adjusted_minimum
              @adjusted_minimum ||= domain.domain_minimum
            end

            def adjusted_maximum
              @adjusted_maximum ||= domain.domain_maximum
            end

            def domain
              @domain ||= Domain.new(minimum:, maximum:, tick_interval: tick_interval.to_f,
                                     mode: ((values_method == :keys && temporal_data?) || discrete? ? :exact : :rounded))
            end

            private

            def interval
              interval_range / TARGET_TICK_COUNT
            end

            def range
              return (maximum.to_time - adjusted_minimum.to_time).abs if temporal_data?

              maximum - adjusted_minimum
            end

            def interval_range
              return (maximum ? 1 : 0) if categorical?
              return (maximum.to_time - minimum.to_time).abs if temporal_data?

              (maximum + adjustment_for_empty_interval) - (minimum - adjustment_for_empty_interval)
            end

            def adjustment_for_empty_interval
              return 0 if minimum != maximum

              (maximum.nil? || maximum.zero? ? 1.0 : (maximum.abs * 0.1)) * 0.5
            end

            def tick_interval
              return 0 if interval <= 0
              return TEMPORAL_INTERVALS.find { it.to_i >= interval } || TEMPORAL_INTERVALS.last if temporal_data?

              tick_base * DECIMAL_INTERVALS.min_by { |n| n < (interval / tick_base) ? Float::INFINITY : n }
            end

            def temporal_data?
              minimum.acts_like?(:time) || minimum.acts_like?(:date)
            end

            def tick_base
              10**BigDecimal(Math.log10(interval).floor)
            end

            def tick_offset
              (100.0 / values_count) / 2 if categorical?
            end
          end
        end
      end
    end
  end
end
