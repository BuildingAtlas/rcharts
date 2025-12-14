# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class Caster
          def initialize(value)
            @value = value
          end

          def casting
            upcast(yield downcast)
          end

          private

          attr_reader :value

          def downcast
            case value
            when Time then value.to_i
            when Date then value.jd + value.day_fraction
            else value
            end
          end

          def upcast(raw)
            case value
            when ActiveSupport::TimeWithZone then value.time_zone.at(raw)
            when Time then Time.at(raw, in: value_zone)
            when DateTime then DateTime.jd(0, 0, 0, 0, value.offset, value.start) + raw
            when Date then Date.jd(raw, value.start)
            else raw
            end
          end

          def value_zone
            value.zone.try { ActiveSupport::TimeZone[it] } || value.utc_offset
          end
        end
      end
    end
  end
end
