# frozen_string_literal: true

module RCharts
  module GraphHelper
    # = \Element
    #
    # The base class for all elements to inherit from. Elements are designed for cases where a tag helper alone
    # would be unwieldy because of the complexity of determining content or attribute values e.g. for SVG positioning
    # attributes like <tt>x</tt> and <tt>y</tt>.
    #
    # To ensure rendering yields a predictable result every time, don't mutate element state as part of the rendering
    # process. If you need to track and mutate state, use ElementBuilder instead, which is designed for this situation.
    #
    # By default, rendering an element produces no content. Subclasses should implement their own private #tags method
    # to return actual content when rendered. All helpers and objects accessible in the parent view context are also
    # accessible within #tags, so you can use tag helpers and other helpers to build markup.
    #
    # To pass a value to an element, first declare an attribute using the ActiveModel::Attributes API
    # and then pass the value to the element's initializer (or use one of the other methods to set attributes).
    # Already declared attributes are #id, #class_names (with writer alias #class=), #data, and #aria.
    class Element
      include ActiveModel::API
      include ActiveModel::Attributes

      class_attribute :view_context

      delegate :render, :tag, to: :view_context
      delegate_missing_to :view_context

      ##
      # :attr_accessor: id
      attribute :id, :string

      ##
      # :attr_accessor:
      attribute :class_names

      ##
      # :attr_writer: class

      ##
      # :attr_accessor:
      attribute :data, default: -> { {} }

      ##
      # :attr_accessor:
      attribute :aria, default: -> { {} }

      alias class= class_names= # :nodoc:

      def render_in(view_context, &)
        with view_context: do
          tags(&)
        end
      end

      private

      # :doc:
      def tags
        ''.html_safe
      end
    end
  end
end
