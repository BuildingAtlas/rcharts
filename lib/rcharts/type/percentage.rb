# frozen_string_literal: true

module RCharts
  module Type
    class Percentage < ActiveModel::Type::Float # :nodoc:
      def type
        :percentage
      end

      private

      def cast_value(value)
        case value
        when RCharts::Percentage then value
        else RCharts::Percentage.new(super)
        end
      end
    end
  end
end
