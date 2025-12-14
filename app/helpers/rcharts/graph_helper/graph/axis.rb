# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axis
        include ActiveModel::API
        include ActiveModel::Attributes

        include Ticks
        include Positioning

        attribute :name, :'rcharts/symbol'
        attribute :index, :integer
        attribute :graphable
        attribute :values_method, default: :values
        attribute :minimum
        attribute :maximum
        attribute :discrete
        attribute :stacked, :boolean, default: false

        alias stacked? stacked

        def discrete?
          discrete.present?
        end

        def categorical?
          discrete == :categorical
        end

        def horizontal?
          name == :x
        end

        def vertical?
          name == :y
        end

        private

        delegate :count, to: :values, prefix: true, private: true

        def minimum
          super || (self.minimum = minima.min) || 0
        end

        def maximum
          super || (self.maximum = maxima.max) || 0
        end

        def minmax
          [minimum, maximum]
        end

        def keys
          graphable.keys
        end

        def values
          @values ||= graphable.then(&values_method).collect { it.is_a?(Hash) ? it.values : Array.wrap(it) }
        end

        def minima
          values.filter_map do |value|
            value.reject { it.try(:positive?) }
                 .compact
                 .presence
                 .try(&(stacked? ? :sum : :min))
                 .then { it || value.compact.min }
          end
        end

        def maxima
          values.filter_map do |value|
            value.reject { it.try(:negative?) }
                 .compact
                 .presence
                 .try(&(stacked? ? :sum : :max))
                 .then { it || value.compact.max }
          end
        end
      end
    end
  end
end
