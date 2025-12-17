# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Series
      class SeriesElement < Element
        attribute :composition, default: -> { Graph::Composition.new }
        attribute :series_options, default: -> { {} }
        attribute :series_names

        private

        def tags(&)
          tag.svg class: 'series-container' do
            selected_series.each do |key|
              concat render SeriesBuilder.new(name: key, index: series_options.keys.index(key),
                                              series_options: series_options.fetch(key, {}),
                                              composition:), &
            end
          end
        end

        def selected_series
          series_options.keys.reject { series_names.presence&.exclude?(it) }
        end
      end
    end
  end
end
