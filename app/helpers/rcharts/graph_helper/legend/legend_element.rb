# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Legend
      class LegendElement < Element
        attribute :series_options, default: -> { {} }
        attribute :placement, default: 'bottom'

        private

        def tags(&)
          tag.ul class: 'legend', data: { placement: } do
            series_options.each_key.with_index do |key, index|
              concat item_tag_for(key, index, &)
            end
          end
        end

        def item_tag_for(key, index, &)
          tag.li class: 'legend-item' do
            render EntryBuilder.new(name: key, index:, series_options: series_options[key]), &
          end
        end
      end
    end
  end
end
