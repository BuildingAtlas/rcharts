# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class Caster # :nodoc:
          EPOCH_OFFSET = Time.at(0, in: 'Z').to_date.jd

          def initialize(value)
            @value = value
          end

          def casting
            upcast(yield downcast)
          end

          def downcast
            case value
            when Time then value.to_i
            when Date then julian_days.to_i
            else value
            end
          end

          private

          attr_reader :value

          def upcast(raw)
            case value
            when ActiveSupport::TimeWithZone then value.time_zone.at(raw)
            when Time then value.class.at(raw, in: value_zone)
            when Date then upcast_date(raw)
            else raw
            end
          end

          def upcast_date(raw)
            raw.seconds.in_days.divmod(1).then do |days, fraction|
              value.class.jd(EPOCH_OFFSET + days, *datetime_args, value.start) + fraction
            end
          end

          def datetime_args
            [0, 0, 0, value.offset] if value.is_a?(DateTime)
          end

          def julian_days
            ((value.jd - EPOCH_OFFSET) + (value.day_fraction - value.try(:offset).to_f)).days
          end

          def value_zone
            value.zone.try { ActiveSupport::TimeZone[it] } || value.utc_offset
          end
        end
      end
    end
  end
end
