# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      class EntryBuilder < ElementBuilder
        attribute :value
        attribute :name
        attribute :index, :integer, default: 0
        attribute :series_options, default: -> { {} }

        def dot
          tag.span symbol, class: ['series-symbol', color_class]
        end

        private

        def color_class
          series_options.fetch(:color_class, RCharts.color_class_for(index))
        end

        def symbol
          series_options.fetch(:symbol, RCharts.symbol_for(index))
        end
      end
    end
  end
end
