# RCharts

RCharts is a charting library for Action View which produces JS-agnostic SVG charts.

In the time since popular JS charting libraries were created, significant advances in CSS have made it possible
to use the browser's rendering engine for more and more things where JS was previously unavoidable.
Rather than starting from the assumption that client-side rendering in JS is inevitable for charts, RCharts builds
on the premise that decent baseline functionality is now possible just with server-side rendering.

Being able to lean on the browser's rendering engine results in visibly improved client-side rendering performance
and eliminates the scope for undesirable interactions with other rendering in JS. This makes it possible to layer
interactivity on top of charts much more reliably, because the chart is no different from the rest of the page.
One possible progressive enhancement would be panning and zooming, using a Stimulus controller to send a request
to the server and reload the chart with different parameters.

RCharts was conceived specifically with Turbo morphing in mind. Because morphing is able to update pages and frames
at the level of individual attributes, when CSS transitions are added to SVG elements, properties determining placement
and size of elements can be animated like any other. Like other styling, you can control all aspects of the transitions
using CSS, by overriding variables in the stylesheet provided or by using your own styles.

To be useful to a wider audience, charting libraries need to be flexible enough to cover a wide range of use cases.
RCharts aims to provide a comprehensive set of features that cover the most common use cases, with more to come.
It currently supports:

* Different chart types
    * Line charts
    * Bar charts
    * Horizontal bar charts
    * Area charts
    * Scatter plots
    * Combinations of the above
* Proper value handling
    * Stacked area and bar charts
    * Smoothing for line and area charts (you can choose by how much but not the method)
    * Negative values (e.g. with split series for stacked area charts)
    * Masks for missing values
* Various axis options
    * Automatic axis ticks based on the type and values of provided data
    * Axis labels formatted however you want
    * Axis labels rotation and hiding to avoid overlap
    * Axis titles
    * Multiple parallel axes based on potentially different data
* Tooltips and legends
    * Tooltips containing whatever you want
    * Legend with placement in all directions
    * Custom series symbols and colours
* Sparklines, by only rendering the chart itself
* CSS that you can customise to your liking, both by setting variables and/or using your own styles

## Usage

The API is inspired by the venerable `ActionView::Helpers::FormBuilder`.

To get started, take a look at the WIP docs for `RCharts::GraphHelper`, and also run the dummy app which shows
the different chart types and how to combine them with morphing.

```bash
$ git clone "https://github.com/BuildingAtlas/rcharts.git"
$ cd rcharts/test/dummy
$ rails s
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rcharts'
```

And then execute:

```bash
$ bundle
```

Install the stylesheet:

```bash
$ rails rcharts:install
```

Finally, include the helper in `ApplicationHelper`:

```ruby
# app/helpers/application_helper.rb

module ApplicationHelper
  include RCharts::GraphHelper
end
```

## Contributing

Contributions are welcome, but please open an issue first to discuss what you would like to add or change.

## License

The gem is available as open source under the terms of the [MIT Licence](https://opensource.org/licenses/MIT).
