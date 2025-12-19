# frozen_string_literal: true

module RCharts
  # = \RCharts \Graph Helper
  #
  # The \graph helper is designed to make it easy to create graphs from hashes of data without having to write any SVGs.
  #
  # Creating a graph involves more bookkeeping than you might expect. The axes need to have nice round numbers which fit
  # the data provided, the positions of lines, curves, and bars need to be scaled according to the minimum and maximum
  # nice round numbers as determined, and for stacked bar charts and area charts you need to know how much space
  # has already been used by previous series. All of this bookkeeping can be taken care of by using #graph_for, which
  # takes a hash and instantiates a GraphHelper::GraphBuilder object. This builder object sets up abstract axes for
  # positioning and provides methods to render different parts of the graph using the data in the hash. For example,
  # given a team's favorite fruits, where the keys are fruits and the values are numbers of people,
  #   { 'Apples' => 1, 'Pears' => 8, 'Oranges' => 2, 'Bananas' => 10 }
  # you can render a nice simple bar chart:
  #   <%= graph_for @team.favorite_fruits do |graph| %>
  #     <%= graph.rules :y %>
  #     <%= graph.rules :x, short: true %>
  #     <%= graph.axis :y do |value| %>
  #       <%= number_to_human value %>
  #     <% end %>
  #     <%= graph.axis :x do |value| %>
  #       <%= value.humanize %>
  #     <% end %>
  #     <%= graph.categories do |category| %>
  #       <%= category.bar %>
  #     <% end %>
  #   <% end %>
  # This simple bar chart would yield the following (the hashes in the IDs will differ):
  #   <div class="rcharts-chart">
  #     <svg class="grid">
  #       <svg class="grid-rule-container">
  #         <line x1="0.0%" x2="100.0%" y1="100.0%" y2="100.0%" class="grid-rule"></line>
  #       </svg>
  #       <svg class="grid-rule-container">
  #         <line x1="0.0%" x2="100.0%" y1="88.88888888888889%" y2="88.88888888888889%" class="grid-rule"></line>
  #       </svg>
  #       <!-- ...  -->
  #       <svg class="grid-rule-container">
  #         <line x1="0.0%" x2="100.0%" y1="11.111111111111114%" y2="11.111111111111114%" class="grid-rule"></line>
  #       </svg>
  #       <svg class="grid-rule-container">
  #         <line x1="0.0%" x2="100.0%" y1="0.0%" y2="0.0%" class="grid-rule"></line>
  #       </svg>
  #     </svg>
  #     <svg class="grid">
  #       <svg y="100%" class="grid-rule-container">
  #         <line x1="10.0%" x2="10.0%" y1="0.0%" y2="5.0" class="grid-rule"></line>
  #       </svg>
  #       <svg y="100%" class="grid-rule-container">
  #         <line x1="36.66666666666667%" x2="36.66666666666667%" y1="0.0%" y2="5.0" class="grid-rule"></line>
  #       </svg>
  #       <svg y="100%" class="grid-rule-container">
  #         <line x1="63.33333333333334%" x2="63.33333333333334%" y1="0.0%" y2="5.0" class="grid-rule"></line>
  #       </svg>
  #       <svg y="100%" class="grid-rule-container">
  #         <line x1="90.0%" x2="90.0%" y1="0.0%" y2="5.0" class="grid-rule"></line>
  #       </svg>
  #     </svg>
  #     <style></style>
  #     <div class="axis" data-name="y" data-index="0">
  #       <svg class="axis-ticks" width="2ch" data-axis="272261975180431324">
  #         <svg class="axis-tick" x="100.0%" y="100.0%">
  #           <text class="axis-tick-text" data-inline-axis="y" data-inline-axis-index="0"> 1 </text>
  #         </svg>
  #         <svg class="axis-tick" x="100.0%" y="88.88888888888889%">
  #           <text class="axis-tick-text" data-inline-axis="y" data-inline-axis-index="0"> 2 </text>
  #         </svg>
  #         <!-- ...  -->
  #         <svg class="axis-tick" x="100.0%" y="11.111111111111114%">
  #           <text class="axis-tick-text" data-inline-axis="y" data-inline-axis-index="0"> 9 </text>
  #         </svg>
  #         <svg class="axis-tick" x="100.0%" y="0.0%">
  #           <text class="axis-tick-text" data-inline-axis="y" data-inline-axis-index="0"> 10 </text>
  #         </svg>
  #       </svg>
  #     </div>
  #     <style>
  #       /* ... */
  #     </style>
  #     <div class="axis" data-name="x" data-index="0">
  #       <svg class="axis-ticks" data-axis="1581349059956683109">
  #         <svg class="axis-tick" x="10.0%" y="0.0%">
  #           <text class="axis-tick-text" data-inline-axis="x" data-inline-axis-index="0"> Apples </text>
  #         </svg>
  #         <svg class="axis-tick" x="36.66666666666667%" y="0.0%">
  #           <text class="axis-tick-text" data-inline-axis="x" data-inline-axis-index="0"> Pears </text>
  #         </svg>
  #         <svg class="axis-tick" x="63.33333333333334%" y="0.0%">
  #           <text class="axis-tick-text" data-inline-axis="x" data-inline-axis-index="0"> Oranges </text>
  #         </svg>
  #         <svg class="axis-tick" x="90.0%" y="0.0%">
  #           <text class="axis-tick-text" data-inline-axis="x" data-inline-axis-index="0"> Bananas </text>
  #         </svg>
  #       </svg>
  #     </div>
  #     <svg class="category-container">
  #       <svg x="2.5%" width="15.0%" height="100.0%" class="category">
  #         <rect x="0.0%" y="100.0%" height="11.11111111111111%" width="100.0%" class="series-shape blue"></rect>
  #       </svg>
  #       <svg x="29.16666666666667%" width="15.0%" height="100.0%" class="category">
  #         <rect x="0.0%" y="22.22222222222223%" height="88.88888888888889%" width="100.0%" class="series-shape blue"></rect>
  #       </svg>
  #       <svg x="55.83333333333334%" width="15.0%" height="100.0%" class="category">
  #         <rect x="0.0%" y="88.88888888888889%" height="22.22222222222222%" width="100.0%" class="series-shape blue"></rect>
  #       </svg>
  #       <svg x="82.5%" width="15.0%" height="100.0%" class="category">
  #         <rect x="0.0%" y="0.0%" height="111.11111111111111%" width="100.0%" class="series-shape blue"></rect>
  #       </svg>
  #     </svg>
  #   </div>
  # If you look at the structure of the rendered markup and the class names, you'll see that the order of the different
  # parts of the graph corresponds to the order they were rendered in the <tt>graph_for</tt> block.
  module GraphHelper
    # Creates a graph from a hash.
    #
    # Suppose you have a book model with sales data as a hash, where the keys are the months and the values are
    # the sales figures:
    #
    #   <%= graph_for @book.sales do |graph| %>
    #     <%= graph.rules :y %>
    #     <%= graph.axis :y do |value| %>
    #       <%= number_to_rounded value %>
    #     <% end %>
    #     <%= graph.axis :x do |value| %>
    #       <%= value %>
    #     <% end %>
    #     <%= graph.series do |series| %>
    #       <%= series.line smooth: 0.16 %>
    #     <% end %>
    #   <% end %>
    #
    # The <tt>graph</tt> variable is an GraphHelper::GraphBuilder object which contains the hash of sales
    # figures, and provides methods to render different parts of the graph using the data in the hash. For example,
    #   <%= graph.rules :y %>
    # renders an <tt><svg></tt> tag with horizontal lines aligned with each tick on the Y-axis.
    # The Y-axis itself hasn't been rendered yet, but the tick positioning information has been calculated and stored
    # by the builder for reuse later. The following lines
    #   <%= graph.axis :y do |value| %>
    #     <%= number_with_delimiter value %>
    #   <% end %>
    # then render the axis using the tick positions calculated previously. The block is passed <tt>value</tt>, which
    # is the value associated with the tick. You can use a helper like <tt>number_with_delimiter</tt> to format this
    # however you wish.
    #
    # To actually render the plot itself, you can use GraphHelper::GraphBuilder#series. This will iterate
    # through all the series in the hash and for each one yield a GraphHelper::Series::SeriesBuilder object.
    #   <%= graph.series do |series| %>
    #     <%= series.line smooth: 0.16 %>
    #   <% end %>
    # This example will render a line plot for every series (only one in this case) with smoothing applied.
    #
    # Bar charts work differently because the iteration is by category, not series:
    #   <%= graph.categories do |category| %>
    #     <%= category.bar %>
    #   <% end %>
    # This will render a bar for every category (each of the months).
    #
    # For more information, see GraphHelper::GraphBuilder#series and GraphHelper::GraphBuilder#categories.
    #
    # === Providing data
    #
    # How does graph builder interpret the hash? The default assumption is that the hash keys are the categories,
    # on the X-axis, and the values are the series data on the Y-axis. For example, if you have a hash like this:
    #   { 'January' => { predicted: 10, actual: 20 }, 'February' => { predicted: 20, actual: 30 } }
    # then the categories will be <tt>['January', 'February']</tt> and the series will be
    # <tt>[:predicted, :actual]</tt>. If you only have one series, then you don't need to specify it in a hash:
    #   { 'January' => 40, 'February' => 50 }
    # In this case the single series is actually labelled <tt>nil</tt>, the default series name,
    # so you don't need to specify it when rendering plots.
    #
    # In this case the hash keys are all strings, so the X-axis is treated as categorical, which means extra
    # padding on a bar chart. \Axes can be continuous (values that can be interpolated),
    # discrete (values that cannot be interpolated e.g. because they must be integers),
    # or categorical (values that represent characteristics), and in this system categorical is treated as
    # a subcase of discrete. So if the hash keys had been month numbers, for example, but you wanted them to be treated
    # as categorical, then it would be necessary to specify the axis type as <tt>discrete: :categorical</tt>.
    #   <%= graph_for @book.sales, axis_options: { x: { discrete: :categorical } do |graph| %>
    # If you wanted to treat them as discrete, then you would specify the axis type as <tt>discrete: true</tt>.
    #   <%= graph_for @book.sales, axis_options: { x: { discrete: true } do |graph| %>
    #
    # === Customizing the styling
    #
    # Running <tt>rails rcharts:install</tt> copies a stylesheet to <tt>app/assets/stylesheets/rcharts.css</tt>.
    # At the beginning of the stylesheet are default values for a number of variables used later.
    #   /* app/assets/stylesheets/rcharts.css */
    #
    #   :where(.rcharts-chart) {
    #     --red: #F44336;
    #     --blue: #2196F3;
    #     --green: #4CAF50;
    #     /* ... */
    #   }
    # If you only want to override these values, you can add a rule to your application stylesheet with
    # higher specificity. When updates are made to the installed stylesheet, you can replace your version with
    # the new version, and your overrides will be preserved.
    #   /* app/assets/stylesheets/application.css */
    #
    #   .rcharts-chart {
    #     --red: #FF0000;
    #   }
    # For more radical overrides, you can change the installed stylesheet and integrate subsequent updates
    # yourself.
    #
    # === Setting options
    #
    # You can set data attributes using the <tt>:data</tt> key, and other attributes using the <tt>:html</tt> key.
    # You can also use the <tt>:builder</tt> key to specify your own subclass of GraphBuilder to use to render the
    # chart. Other options are passed through to the builder, in particular <tt>:axis_options</tt> and
    # <tt>:series_options</tt>.
    #
    # ==== Axis options
    #
    # The <tt>:axis_options</tt> key is used to specify options for the layout axes. For example, the following options
    # could be used with a horizontal bar chart:
    #   <%= graph_for @book.sales,
    #                 axis_options: { x: { minimum: 0, stacked: true, values_method: :values },
    #                                 y: { values_method: :keys } } do |graph| %>
    # It might seem unintuitive to need to specify these options here as opposed to when rendering the axes. The reason
    # is that the axes abstractly affect many aspects of the chart even if they aren't rendered: for example,
    # if categories are positioned along the Y-axis, then bar charts will need to be rendered horizontally.
    #
    # The available options are:
    # [<tt>:discrete</tt>] used to specify that the axis is continuous, using <tt>false</tt>,
    #                      discrete, using <tt>true</tt>, or categorical, using <tt>:categorical</tt>. String values are
    #                      interpreted as categorical.
    # [<tt>:minimum</tt>] used to force the axis to assume a lower bound (otherwise the axis will use a rounded version
    #                     of the lowest value)
    # [<tt>:stacked</tt>] set this to <tt>true</tt> to stack series on top of each other, such as with bar charts and
    #                     area charts
    # [<tt>:values_method</tt>] used to specify a callable to generate the values for the axis. This is useful if you
    #                           want to use a method other than <tt>keys</tt> and <tt>values</tt> to generate the
    #                           X- and Y-axis values (the defaults)
    # ==== \Series options
    #
    # The <tt>:series_options</tt> key is used to specify options for individual series, currently <tt>color_class</tt>
    # and <tt>symbol</tt>.
    # For example, you might want to render chart with a different color or symbol for one of the series:
    #   <%= graph_for @book.sales,
    #                 series_options: { coffee_books: { color_class: 'mocha', symbol: '☕' } } do |graph| %>
    # This will affect any lines, areas, markers, bars, legend entries, and tooltips which reference the series.
    def graph_for(object, builder: GraphBuilder, **, &)
      tag.div class: 'rcharts-chart' do
        render builder.new(graphable: object, **), &
      end
    end
  end
end
