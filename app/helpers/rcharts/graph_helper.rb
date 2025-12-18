# frozen_string_literal: true

module RCharts
  module GraphHelper
    def graph_for(object, **, &)
      tag.div class: 'rcharts-chart' do
        render GraphBuilder.new(graphable: object, **), &
      end
    end
  end
end
