# frozen_string_literal: true

module RCharts
  module Type
    class Symbol < ActiveModel::Type::Value
      include ActiveModel::Type::Helpers::Immutable

      def type
        :symbol
      end

      def serialize(value)
        case value
        when ::String then value.to_sym
        else super.to_sym
        end
      end

      private

      def cast_value(value)
        case value
        when Symbol then value
        else value.to_s.to_sym
        end
      end
    end
  end
end
