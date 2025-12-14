# frozen_string_literal: true

module RCharts
  module GraphHelper
    # = Element Builder
    #
    # Like form builders, but for elements. Concrete builders should inherit from this class.
    # Use this when you need to provide a way for users to choose between different options at rendering time and track
    # rendering state (e.g. to do with iteration).
    #
    # Rendering a builder shouldn't itself render anything. Instead, rendering the builder with a block means that,
    # just as with a form builder, the block will be called with an instance of the builder.
    # That means within the block, users can then call methods on the builder, which may output markup to the buffer.
    # If you need a container element, like the <tt><form></tt> associated with a form builder,
    # keep that separate from the builder.
    #
    # The builder is the place to store information about the state of rendering independent of particular elements.
    # One example is iteration, where users may need to be able to specify different markup for each individual item
    # in the collection. You can allow this by rendering a builder with each object in the collection, declaring
    # an index attribute on the builder to allow different behavior according to the position of the item.
    #
    # Like elements, builders set and delegate to the view context.
    class ElementBuilder
      include ActiveModel::API
      include ActiveModel::Attributes

      class_attribute :view_context

      delegate :render, :tag, to: :view_context
      delegate_missing_to :view_context

      def render_in(view_context, &)
        with view_context: do
          block_given? ? yield(self) : ''.html_safe
        end
      end
    end
  end
end
