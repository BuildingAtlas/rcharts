# frozen_string_literal: true

module RCharts
  class Percentage
    attr_reader :value

    def self.wrap(value)
      value.is_a?(Percentage) ? value : new(value)
    end

    def self.unwrap(value)
      value.is_a?(Percentage) ? value.value : value
    end

    def initialize(value)
      @value = value.to_f
    end

    MAX = new(100.0)
    MIN = new(0.0)

    def ==(other)
      value == self.class.unwrap(other)
    end

    %i[+ - * /].each do |operator|
      define_method operator do |other|
        self.class.new(value.public_send(operator, self.class.unwrap(other)))
      end
    end

    def to_s
      "#{value}%"
    end
  end
end
