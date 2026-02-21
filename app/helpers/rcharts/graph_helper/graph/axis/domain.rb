# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class Domain # :nodoc:
          FLOOR_ALIGNMENT = { ...(2.days.to_i) => -> { it.beginning_of_day },
                              (2.days.to_i)...(2.weeks.to_i) => -> { it.beginning_of_week },
                              (2.weeks.to_i)...(2.months.to_i) => -> { it.beginning_of_month },
                              (2.months.to_i)...(4.months.to_i) => -> { it.beginning_of_quarter },
                              (4.months.to_i)...(10.months.to_i) => -> { it.beginning_of_year.advance(months: it.month < 7 ? 0 : 6) },
                              (10.months.to_i)... => -> { it.beginning_of_year } }.freeze
          MODES = %i[exact rounded].freeze

          def initialize(minimum:, maximum:, tick_interval:, mode:)
            @minimum = minimum
            @maximum = maximum
            @tick_interval = tick_interval
            @mode = mode.presence_in(MODES) || raise(ArgumentError, "mode must be one of #{MODES.collect(&:inspect).join(', ')}")
          end

          def domain_minimum
            return minimum if exact?

            adjusted_minimum
          end

          def domain_maximum
            return maximum if exact?

            adjusted_maximum
          end

          def exact?
            mode == :exact
          end

          def rounded?
            mode == :rounded
          end

          private

          attr_reader :minimum, :maximum, :tick_interval, :mode

          def adjusted_minimum
            @adjusted_minimum ||= calculate_adjusted_minimum
          end

          def calculate_adjusted_minimum
            return minimum if tick_interval.zero?
            return calendar_boundary_for(minimum, tick_interval) if temporal_data?

            Caster.new(minimum).casting { (it / tick_interval).floor * tick_interval }
          end

          def adjusted_maximum
            @adjusted_maximum ||= adjusted_minimum + (tick_count * tick_interval)
          end

          def tick_count
            @tick_count ||= tick_interval.zero? ? 0 : (tick_count_range / tick_interval).ceil
          end

          def tick_count_range
            temporal_data? ? (maximum.to_time - adjusted_minimum.to_time).abs : (maximum - adjusted_minimum).to_f
          end

          def temporal_data?
            minimum.acts_like?(:time) || minimum.acts_like?(:date)
          end

          def calendar_boundary_for(value, interval)
            FLOOR_ALIGNMENT.detect { |range, _| range.cover?(interval) }
                           .last
                           .call(value.to_time)
                           .then { value.acts_like?(:date) ? it.to_date : it }
          end
        end
      end
    end
  end
end
