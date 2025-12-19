# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      class AreaElement < PathElement # :nodoc:
        attribute :previous_series, default: -> { {} }
        attribute :mask_series, default: -> { {} }
        attribute :block_position, :float, default: 0

        private

        delegate :mask_spans, to: :mask_path, private: true

        def path_tag
          tag.path d: path_data, style: "d:path(\"#{path_data}\")", class: ['series-shape', color_class], data:, aria:,
                   mask: "url(##{mask_id})"
        end

        def path_data
          return '' if series.values.compact.all?(&:zero?)

          @path_data ||= area_path
        end

        def previous_points
          return [] if previous_series == series

          previous_series.collect { |key, value| Point.new(key, 100.0 - (value || block_position)) }
        end

        def points
          series.collect { |key, value| Point.new(key, 100.0 - (value || block_position)) }
        end

        def mask_points
          mask_series.collect { |key, value| Point.new(key, value.try { 100.0 - it }) }
        end

        def path
          Path.new(points, previous_points, origin: block_position, smoothing: smooth)
        end

        def mask_path
          Path.new(mask_points, origin: block_position, smoothing: smooth)
        end
      end
    end
  end
end
