# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Graph
      class Axes
        delegate :[], to: :axes

        def initialize(graphable = {}, axis_options = {})
          @axes = Options.new(graphable.keys, axis_options).to_h do |name, axes|
            [name, axes.collect { |index, options| build_axis(graphable:, name:, index:, **options) }]
          end
        end

        def fetch(name, index = 0)
          axes.fetch(name) { raise ArgumentError, "Unknown axis #{name}" }
              .fetch(index) { raise ArgumentError, "Unknown index #{index} for axis #{name}" }
        end

        def discrete
          fetch(:x).then { it.discrete? && it } || axes.values.flatten.find(&:discrete?) || fetch(:x)
        end

        def continuous
          fetch(:y).then { !it.discrete? && it } || axes.values.flatten.find { !it.discrete? } || fetch(:y)
        end

        private

        attr_reader :axes

        def build_axis(graphable:, name:, index:, **options)
          discrete = case options[:values_method].to_proc.call(graphable).first
                     when String, Symbol then :categorical
                     end
          Axis.new(graphable:, name:, index:, discrete:, **options)
        end
      end
    end
  end
end
