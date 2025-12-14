# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Legend
      class EntryBuilder < ElementBuilder
        attribute :name
        attribute :index, :integer, default: 0
        attribute :series_options, default: -> { {} }

        def dot
          tag.span symbol, class: ['series-symbol', color_class]
        end

        private

        delegate :color_class_for, :symbol_for, to: RCharts, private: true

        def color_class
          series_options.fetch(:color_class, color_class_for(index))
        end

        def symbol
          series_options.fetch(:symbol, symbol_for(index))
        end
      end
    end
  end
end
