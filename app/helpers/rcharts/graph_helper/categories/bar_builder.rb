# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Categories
      class BarBuilder < ElementBuilder
        attribute :name
        attribute :inline_size, :'rcharts/percentage', default: Percentage::MAX
        attribute :block_size, :'rcharts/percentage', default: Percentage::MAX
        attribute :block_position, :'rcharts/percentage', default: Percentage::MIN
        attribute :inline_index, :integer, default: 0
        attribute :series_index, :integer, default: 0
        attribute :horizontal, :boolean, default: false
        attribute :series_options, default: -> { {} }

        def bar(**)
          render BarSegmentElement.new(inline_size:, block_size:, block_position:, inline_index:, series_index:,
                                       horizontal:, series_options:, **)
        end
      end
    end
  end
end
