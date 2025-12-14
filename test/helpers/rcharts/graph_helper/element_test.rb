# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    class ElementTest < ActionView::TestCase
      class TestElement < Element
        attribute :value, :integer

        def tags
          block_given? ? yield(self) : tag.span(value || number_to_human(42), id:, class: class_names, data:, aria:)
        end
      end

      setup do
        @element = Element.new
        @test_element = TestElement.new
      end

      test 'renders base element' do
        assert_empty render @element
      end

      test 'delegates missing to view context' do
        assert_dom_equal <<~HTML, render(@test_element)
          <span>42</span>
        HTML
      end

      test 'allows declaring attributes' do
        @test_element.value = 2.5

        assert_dom_equal <<~HTML, render(@test_element)
          <span>2</span>
        HTML
      end

      test 'allows passing a block' do
        assert_dom_equal <<~HTML, render(@test_element) { tag.span 43 }
          <span>43</span>
        HTML
      end

      test 'has ID attribute' do
        @test_element.id = '43'

        assert_dom_equal <<~HTML, render(@test_element)
          <span id="43">42</span>
        HTML
      end

      test 'has class names attribute' do
        @test_element.class_names = ['42']
        @test_element.class_names << '43'

        assert_dom_equal <<~HTML, render(@test_element)
          <span class="42 43">42</span>
        HTML
        @test_element.class = '43'

        assert_dom_equal <<~HTML, render(@test_element)
          <span class="43">42</span>
        HTML
      end

      test 'has data attribute' do
        @test_element.data = { foo: true }

        assert_dom_equal <<~HTML, render(@test_element)
          <span data-foo="true">42</span>
        HTML
      end

      test 'has aria attribute' do
        @test_element.aria = { label: 'foo' }

        assert_dom_equal <<~HTML, render(@test_element)
          <span aria-label="foo">42</span>
        HTML
      end
    end
  end
end
