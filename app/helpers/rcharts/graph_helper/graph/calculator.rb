# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Calculator # :nodoc:
        delegate :[], :dig, to: :to_h

        def initialize(values = {})
          @values = values
          @chain = []
          @selections = {}
        end

        def sum_complete
          values.transform_values do |value|
            case value
            when Hash then value.values.any?(nil) ? nil : value.values.sum
            when Array then value.any?(nil) ? nil : value.sum
            else value
            end
          end
        end

        def signed(sign = nil)
          return self unless sign

          apply sign do
            values_for_predicate sign == :positive ? :positive? : :negative?
          end
        end

        def stacked(exclude_current: false)
          apply :stacked, exclude_current do
            collect_sum inclusive: !exclude_current
          end
        end

        def to_h
          keys.index_with do |key|
            next values if key.nil?

            values.transform_values { it[key] }
          end
        end

        protected

        attr_accessor :values, :chain

        def apply!(*operation)
          selections[[*chain, *operation]] ||= yield if block_given?
          self.chain = chain.dup
          chain.append(*operation)
          self.values = selections[chain]
        end

        private

        attr_reader :selections

        def apply(*operation, &)
          selections[[*chain, *operation]] ||= yield if block_given?
          dup.tap { it.apply!(*operation) }
        end

        def keys
          case values.values.first
          in Hash => value then value.keys
          in Array => value then (0...value.size).to_a
          else [nil]
          end
        end

        def values_for_predicate(predicate)
          values.deep_transform_values { it.try(predicate) == false ? nil : it }
        end

        def collect_sum(inclusive: true)
          values.transform_values do |value|
            value.keys.index_with do |key|
              value.keys.index(key).then do |limit|
                value.values.slice(inclusive ? 0..limit : 0...limit).compact.presence&.sum
              end
            end
          end
        end
      end
    end
  end
end
