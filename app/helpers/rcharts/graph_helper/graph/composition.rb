# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Composition # :nodoc:
        attr_reader :axes

        delegate :sum_complete, :signed, :stacked, to: :calculator
        delegate :keys, to: :data

        def initialize(graphable = {}, axis_options = {})
          @data = graphable
          @axes = Axes.new(graphable, axis_options)
        end

        def values
          @values ||= case data.values.first
                      in Hash then data
                      in Array then data.transform_values { it.index_with.with_index { |_, index| index } }
                      else data.transform_values { { nil => it } }
                      end
        end

        private

        attr_reader :data

        def calculator
          @calculator ||= Calculator.new(data)
        end
      end
    end
  end
end
