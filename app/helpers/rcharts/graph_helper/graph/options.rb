# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Options
        DEFAULTS = { x: { 0 => { values_method: :keys } }, y: { 0 => { values_method: :values } } }.freeze

        def initialize(keys, options)
          @keys = keys
          @options = options
        end

        def to_h(&)
          DEFAULTS.deep_merge(normalized_options).to_h(&)
        end

        private

        attr_reader :keys, :options

        def normalized_options
          options.transform_values do |value|
            next value.each_with_index.to_h { |item, index| [index, item] } if value.is_a?(Array)
            next value if value.is_a?(Hash) && value.keys.first.is_a?(Integer)

            { 0 => value }
          end
        end
      end
    end
  end
end
