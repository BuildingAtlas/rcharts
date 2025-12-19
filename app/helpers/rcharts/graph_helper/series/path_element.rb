# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      class PathElement < Element # :nodoc:
        attribute :series_options, default: -> { {} }
        attribute :series, default: -> { {} }
        attribute :index, :integer, default: 0
        attribute :smoothing, :float
        attribute :horizontal, :boolean, default: false
        attribute :id_hash, :string, default: -> { SecureRandom.hex(4) }

        alias_attribute :smooth, :smoothing

        private

        alias horizontal? horizontal

        delegate :line_path, :area_path, :mask_spans, to: :path, private: true

        def tags
          tag.svg class: 'series', height: '100%', width: '100%',
                  'viewBox' => '0 0 100 100', 'preserveAspectRatio' => 'none' do
            series_tag
          end
        end

        def series_tag
          mask_tag + path_tag
        end

        def path_tag
          tag.path d: path_data, style: "d:path(\"#{path_data}\")", class: ['series-path', color_class, class_names], data:, aria:,
                   mask: "url(##{mask_id})"
        end

        def path_data
          @path_data ||= line_path
        end

        def color_class
          series_options.fetch(:color_class, RCharts.color_class_for(index))
        end

        def points
          series.collect { |key, value| Point.new(key, value.try { 100.0 - it }) }
        end

        def path
          Path.new(points, smoothing:)
        end

        def mask_tag
          tag.mask id: mask_id, maskUnits: 'userSpaceOnUse', maskContentUnits: 'userSpaceOnUse' do
            concat tag.rect x: '-50%', y: '-50%', width: '200%', height: '200%', fill: 'black'
            mask_spans.each { concat mask_rect_tag_for(it) }
          end
        end

        def mask_rect_tag_for(span)
          tag.rect x: '-50%', y: '-50%', width: '200%', height: '200%', fill: 'white',
                   **span.slice(*(horizontal? ? %i[x width] : %i[y height]))
        end

        def mask_id
          ['series-mask', id_hash].join('-')
        end
      end
    end
  end
end
