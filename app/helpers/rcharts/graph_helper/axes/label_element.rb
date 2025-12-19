# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Axes
      class LabelElement < Element # :nodoc:
        attribute :label
        attribute :horizontal, :boolean

        private

        alias horizontal? horizontal

        def tags
          tag.svg class: 'axis-label', overflow: 'visible', width:, height: do
            tag.svg x: '50%', y: '50%', overflow: 'visible' do
              tag.text label, class: 'axis-label-text'
            end
          end
        end

        def width
          horizontal? ? Percentage::MAX : '1lh'
        end

        def height
          horizontal? ? '1lh' : Percentage::MAX
        end
      end
    end
  end
end
