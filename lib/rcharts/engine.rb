# frozen_string_literal: true

module RCharts
  class Engine < ::Rails::Engine
    isolate_namespace RCharts

    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'RCharts'
    end
  end
end
