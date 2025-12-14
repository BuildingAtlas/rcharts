# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    class ElementBuilderTest < ActionView::TestCase
      class TestBuilder < ElementBuilder
        attribute :value, :integer

        def content
          tag.span(number_to_human(42))
        end
      end

      setup do
        @builder = ElementBuilder.new
        @test_builder = TestBuilder.new
      end

      test 'renders base builder' do
        assert_empty render @builder
      end

      test 'renders nothing by default' do
        assert_empty render(@test_builder)
      end

      test 'delegates missing to view context' do
        assert_dom_equal <<~HTML, render(@test_builder, &:content)
          <span>42</span>
        HTML
      end
    end
  end
end
