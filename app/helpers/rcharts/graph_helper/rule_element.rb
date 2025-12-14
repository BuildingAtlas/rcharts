# frozen_string_literal: true

module RCharts
  module GraphHelper
    class RuleElement < Element
      attribute :horizontal_axis, :boolean, default: false
      attribute :axis_index, :integer, default: 0
      attribute :short, :boolean, default: false
      attribute :gutter, :float, default: 0
      attribute :position, :'rcharts/percentage', default: Percentage::MIN
      attribute :emphasis
      attribute :value

      private

      alias horizontal_axis? horizontal_axis
      alias short? short

      def tags
        tag.svg y:, x:, class: 'grid-rule-container' do
          tag.line x1:, x2:, y1:, y2:, class: ['grid-rule', { 'emphasis' => emphasis_value }]
        end
      end

      def y
        '100%' if short? && horizontal_axis? && axis_index.zero?
      end

      def x
        '100%' if short? && !horizontal_axis? && axis_index.positive?
      end

      def x1
        horizontal_axis? ? position : start
      end

      def x2
        horizontal_axis? ? position : finish
      end

      def y1
        horizontal_axis? ? start : Percentage::MAX - position
      end

      def y2
        horizontal_axis? ? finish : Percentage::MAX - position
      end

      def finish
        return Percentage::MAX unless short?
        return Percentage::MIN unless horizontal_axis?

        (gutter / 2) * (axis_index.zero? ? 1 : -1)
      end

      def start
        return Percentage::MIN unless short?
        return Percentage::MIN if horizontal_axis?

        (gutter / 2) * (axis_index.zero? ? -1 : 1)
      end

      def emphasis_value
        emphasis.respond_to?(:to_proc) ? value.then(&emphasis) : emphasis
      end
    end
  end
end
