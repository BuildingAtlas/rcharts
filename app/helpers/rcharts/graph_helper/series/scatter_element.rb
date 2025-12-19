# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      class ScatterElement < PathElement # :nodoc:
        attribute :marker_size, :float, default: 10
        attribute :marker_margin, :float, default: 2
        attribute :marker_id

        private

        def tags
          series_tag
        end

        def series_tag
          tag.g do
            definitions_tag + path_tag
          end
        end

        def path_tag
          tag.g do
            points.select(&:complete?).each do |point|
              concat dot_for(point)
            end
          end
        end

        def definitions_tag
          tag.defs do
            cross_tag unless marker_id
          end
        end

        def cross_tag
          tag.symbol id:, x:, y:, width:, height: do
            line_tag + line_tag(invert_x: true)
          end
        end

        def line_tag(invert_x: false)
          tag.line x1: invert_x ? marker_size : marker_margin, x2: invert_x ? marker_margin : marker_size, y1:, y2:,
                   class: 'series-path'
        end

        def dot_for(point)
          tag.use href: marker_id || "##{id}", x: Percentage.new(point.x), y: Percentage.new(point.y),
                  class: ['series-path', color_class]
        end

        def id
          [id_hash, :marker].join('-')
        end

        def x
          total_size / -2
        end

        def y
          total_size / -2
        end

        def width
          total_size
        end

        def height
          total_size
        end

        def y1
          marker_margin
        end

        def y2
          marker_size
        end

        def total_size
          marker_size + marker_margin
        end
      end
    end
  end
end
