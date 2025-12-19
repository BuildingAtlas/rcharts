# frozen_string_literal: true

module RCharts
  module GraphHelper
    module Tooltips
      # = Tooltip Builder
      class TooltipBuilder < ElementBuilder
        ##
        # :attr_accessor:
        attribute :name

        attribute :values, default: -> { {} }
        attribute :series_options, default: -> { {} }

        # Renders one or more series present in the data. For each series yields an EntryBuilder which
        # contains the index, key, and value. See EntryBuilder for details.
        #   <%= graph_for @annual_sales do |graph| %>
        #     <%= graph.tooltips do |category| %>
        #       <h4><%= category.name %></h4>
        #       <%= category.series do |series| %>
        #         <%= series.name %>
        #         <%= series.value %>
        #       <% end %>
        #     <% end %>
        #   <% end %>
        def series(**, &)
          capture do
            series_options.each_key.with_index do |key, index|
              concat series_tag(key, index, **, &)
            end
          end
        end

        private

        def series_tag(name, index, **, &)
          tag.div(**) do
            render EntryBuilder.new(name:, value: values[name], index:, series_options: series_options[name]), &
          end
        end
      end
    end
  end
end
