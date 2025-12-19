# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Legend
      # = \Legend Entry Builder
      class EntryBuilder < ElementBuilder
        ##
        # :attr_accessor:
        attribute :name

        ##
        # :attr_accessor: index
        attribute :index, :integer, default: 0

        attribute :series_options, default: -> { {} }

        # Renders the symbol associated with the series. You can override this on a per-series basis using
        # <tt>:series_options</tt> with GraphHelper#graph_for.
        # To change the global set of symbols and colors, see RCharts.symbol_for and RCharts.color_class_for.
        #   <%= graph_for @annual_sales do |graph| %>
        #     <%= graph.tooltips do |category| %>
        #       <h4><%= category.name %></h4>
        #       <%= category.series do |series| %>
        #         <%= series.dot %>
        #         <%= series.name %>
        #       <% end %>
        #     <% end %>
        #   <% end %>
        def dot
          tag.span symbol, class: ['series-symbol', color_class]
        end

        private

        delegate :color_class_for, :symbol_for, to: RCharts, private: true

        def color_class
          series_options.fetch(:color_class, color_class_for(index))
        end

        def symbol
          series_options.fetch(:symbol, symbol_for(index))
        end
      end
    end
  end
end
