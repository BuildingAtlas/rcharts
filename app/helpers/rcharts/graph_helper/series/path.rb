# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      class Path # :nodoc:
        class PathBuffer < String # :nodoc:
          SEPARATOR = ' '

          def concat(*objects)
            return super if empty? || objects.empty?

            super(SEPARATOR, objects.compact_blank.join(SEPARATOR))
          end

          def <<(object)
            return super if object.blank?

            concat object
          end

          def prepend(*other_strings)
            return super if empty? || other_strings.empty?

            super(other_strings.compact_blank.join(SEPARATOR), SEPARATOR)
          end
        end

        POINT_SIZE = 38

        def initialize(points = [], previous_points = [], origin: 0, smoothing: nil)
          @points = points
          @previous_points = previous_points
          @smoothing = smoothing
          @origin = origin
        end

        def line_path
          if compacted_points.empty?
            ''
          else
            line_or_curve_data.prepend(initial_line_data)
          end
        end

        def area_path
          if compacted_points.empty?
            ''
          else
            line_or_curve_data.prepend(*initial_area_data).concat(*final_area_data, previous_line_or_curve_data)
          end
        end

        def mask_spans
          points.compact.chunk(&:complete?).filter_map do |complete, chunk|
            next unless complete

            chunk.sort_by!(&:x)
            chunk.first => { x:, y: }
            chunk.last - chunk.first => { x: width, y: height }
            { x:, y:, width:, height: }
          end
        end

        private

        attr_reader :points, :previous_points, :smoothing, :origin
        attr_accessor :buffer

        def line_or_curve_data
          smoothing ? curve_data : line_data
        end

        def line_data
          capture capacity: estimated_serialized_length do
            compacted_points.each { concat line_to(it) }
          end
        end

        def curve_data
          capture capacity: estimated_serialized_length * 3 do
            compacted_points.values_at(0, 0..-1, -1).each_cons(4) { concat curve_for(*it, smoothing) }
          end
        end

        def previous_line_or_curve_data
          smoothing ? previous_curve_data : previous_line_data
        end

        def previous_line_data
          capture capacity: estimated_serialized_length do
            compacted_previous_points.reverse_each { concat line_to(it) }
          end
        end

        def previous_curve_data
          capture capacity: estimated_serialized_length * 3 do
            compacted_previous_points.values_at(0, 0..-1, -1)
                                     .each_cons(4)
                                     .reverse_each { concat curve_for(*it.reverse, smoothing) }
          end
        end

        def initial_line_data
          move_to compacted_points.first
        end

        def initial_area_data
          [move_to(Point.new(compacted_points.first.x, 100 - origin)), line_to(compacted_points.first)]
        end

        def final_area_data
          [line_to(Point.new(compacted_points.last.x, 100 - origin)), line_to(compacted_previous_points.last)]
        end

        def move_to(point)
          "M #{point}" if point
        end

        def line_to(point)
          "L #{point}" if point
        end

        def curve_for(previous_point, current, next_point, subsequent_point, smoothing)
          "C #{current.control(previous_point, next_point, smoothing:)} " \
            "#{next_point.control(current, subsequent_point, smoothing:, reverse: true)} " \
            "#{next_point}"
        end

        def estimated_serialized_length
          compacted_points.size * POINT_SIZE
        end

        def estimated_previous_serialized_length
          compacted_previous_points.size * POINT_SIZE
        end

        def capture(capacity: nil)
          self.buffer = PathBuffer.new(capacity:)
          yield
          buffer
        end

        def concat(*objects)
          objects.each { buffer.concat it }
        end

        def compacted_points = points.compact.select(&:complete?)
        def compacted_previous_points = previous_points.compact.select(&:complete?)
      end
    end
  end
end
