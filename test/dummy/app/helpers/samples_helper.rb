# frozen_string_literal: true

module SamplesHelper
  include RCharts::GraphHelper

  def line_graph_for(graphable, name, **options)
    render partial: 'line_graph', layout: 'article', locals: { name:, graphable:, **options }
  end

  def area_graph_for(graphable, name, **options)
    render partial: 'area_graph', layout: 'article', locals: { name:, graphable:, **options }
  end

  def scatter_graph_for(graphable, name, **options)
    render partial: 'scatter_graph', layout: 'article', locals: { name:, graphable:, **options }
  end

  def bar_chart_for(graphable, name, **options)
    render partial: 'bar_chart', layout: 'article', locals: { name:, graphable:, **options }
  end

  def horizontal_bar_chart_for(graphable, name, **options)
    render partial: 'horizontal_bar_chart', layout: 'article', locals: { name:, graphable:, **options }
  end

  def mixed_chart_for(graphable, name, **options)
    render partial: 'mixed_chart', layout: 'article', locals: { name:, graphable:, **options }
  end
end
