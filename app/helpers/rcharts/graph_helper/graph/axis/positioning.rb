# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        module Positioning # :nodoc:
          QUANTIZATION = { ...(5.days) => :adjusted_minimum,
                           (5.days)...(2.weeks) => :week_start,
                           (2.weeks)...(2.months) => :month_start,
                           (2.months)...(4.months) => :quarter_start,
                           (4.months)...(10.months) => :half_year_start,
                           (10.months)... => :year_start }.freeze
          ROUNDING = { ...(1.day) => -> { it },
                       (1.day)...(7.days) => -> { it.in_days.round.days },
                       (7.days)...(1.month) => -> { it.in_weeks.round.weeks },
                       (1.month)...(1.year) => -> { it.in_months.round.months },
                       (1.year)... => -> { it.in_years.round.years } }.freeze

          extend ActiveSupport::Concern
          include Ticks

          included do
            def ticks
              return {} unless values.any?

              @ticks ||= Array.new(tick_count.succ) { value_at(it) }
                              .reject { it.nil? || it > adjusted_maximum }
                              .index_by { position_for(it) }
            end

            def value_at(index)
              return if index > tick_count || index.negative? || values.empty?
              return values.dig(index, 0) if discrete

              quantized_adjusted_minimum + (index * rounded_tick_interval)
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

            def position_at(index)
              return if index > tick_count

              (tick_offset.to_f + raw_position_at(index))
            end

            private

            def raw_position_at(index)
              index * (100.0 / ((categorical? ? values_count.nonzero? : tick_count.nonzero?) || 1))
            end

            def downcasted_position_for(value)
              ((Caster.new(value).downcast.to_f - Caster.new(adjusted_minimum).downcast) / casted_range) * 100
            end

            def casted_range
              Caster.new(adjusted_maximum).downcast - Caster.new(adjusted_minimum).downcast
            end

            def rounded_tick_interval
              return tick_interval unless temporal_data?

              ROUNDING.detect { |range, _value| range.cover?(tick_interval) }
                      .last
                      .call(tick_interval)
            end

            def quantized_adjusted_minimum
              return adjusted_minimum unless temporal_data?

              QUANTIZATION.detect { |range, _value| range.cover?(tick_interval) }
                          .last
                          .then { send(it) }
                          .then { tick_interval < 1.day ? it.to_time : it }
            end

            def week_start
              adjusted_minimum.days_to_week_start.zero? ? adjusted_minimum.beginning_of_week : adjusted_minimum.next_week
            end

            def month_start
              adjusted_minimum.mday == 1 ? adjusted_minimum.beginning_of_month : adjusted_minimum.next_month.beginning_of_month
            end

            def quarter_start
              if adjusted_minimum.yday == adjusted_minimum.beginning_of_quarter.yday
                adjusted_minimum.beginning_of_quarter
              else
                adjusted_minimum.next_quarter.beginning_of_quarter
              end
            end

            def half_year_start
              return adjusted_minimum if adjusted_minimum.month.modulo(6) == 1 && adjusted_minimum.mday == 1

              adjusted_minimum.beginning_of_year.advance(months: adjusted_minimum.month < 7 ? 6 : 12)
            end

            def year_start
              adjusted_minimum.yday == 1 ? adjusted_minimum.beginning_of_year : adjusted_minimum.next_year.beginning_of_year
            end
          end
        end
      end
    end
  end
end
