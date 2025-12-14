# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class TooltipBuilder < ElementBuilder
        attribute :series_options, default: -> { {} }
        attribute :name
        attribute :values, default: -> { {} }

        def series(**, &)
          capture do
            series_options.each_key.with_index do |key, index|
              concat series_tag(key, index, **, &)
            end
          end
        end

        private

        def series_tag(name, index, **, &)
          tag.div(**) do
            render EntryBuilder.new(name:, value: values[name], index:, series_options: series_options[name]), &
          end
        end
      end
    end
  end
end
