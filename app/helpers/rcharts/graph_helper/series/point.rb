# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      Point = Struct.new(:x, :y) do
        def to_s = "#{x},#{y}"

        def +(other) = Point.new(x + other.x, y + other.y)

        def -(other) = Point.new(x - other.x, y - other.y)

        def control(previous_point, next_point, smoothing: 1.0, reverse: false)
          (self + handle_offset(previous_point, next_point, smoothing:, reverse:)).then do |control|
            clamp(control, (reverse ? previous_point : next_point))
          end
        end

        def incomplete?
          x.nil? || y.nil?
        end

        def complete?
          !incomplete?
        end

        protected

        def handle_offset(previous_point, next_point, smoothing: 1.0, reverse: false)
          (next_point - previous_point).handle_position(smoothing: smoothing, reverse: reverse,
                                                        extremum: extremum?(previous_point, next_point))
        end

        def handle_position(smoothing: 1.0, reverse: false, extremum: false)
          Point.new(Math.cos(angle(reverse:)) * length(smoothing:),
                    extremum ? 0 : Math.sin(angle(reverse:)) * length(smoothing:))
        end

        private

        def angle(reverse: false) = Math.atan2(y, x) + (reverse ? Math::PI : 0)

        def length(smoothing: 1.0) = Math.sqrt((x**2) + (y**2)) * smoothing

        def extremum?(previous_point, next_point) = (y - previous_point.y) * (next_point.y - y) <= 0

        def clamp(control, limit)
          Point.new(clamp_point(:x, control, limit), clamp_point(:y, control, limit))
        end

        def clamp_point(point, control, limit)
          control[point].clamp(*[self[point], limit[point]].minmax)
        end
      end
    end
  end
end
