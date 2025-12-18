# frozen_string_literal: true

class Sample
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :pulses, :boolean, default: false

  alias pulses? pulses

  def pulses=(value)
    super
    Pulse.enable! if pulses
  end

  def points
    { 1.0 => randomize(10), 2.0 => randomize(20.5), 3.0 => nil, 4.0 => randomize(4), 5.0 => randomize(40) }
  end

  def times
    (0..50).to_a.to_h { [(it * 10).minutes.from_now, (it % 28).zero? ? nil : randomize(100)] }
  end

  def ugly_points
    { 1.0 => randomize(190), 2.0 => randomize(103.5), 3.0 => nil, 4.0 => randomize(10) }
  end

  def negative_points
    { 1.0 => randomize(-10), 2.0 => randomize(-103.5), 3.0 => randomize(-43), 4.0 => randomize(-1) }
  end

  def mixed_points
    { 1.0 => randomize(10), 2.0 => randomize(103.5), 3.0 => randomize(-43), 4.0 => randomize(1) }
  end

  def series_points
    { 1.0 => { prediction: randomize(10), actual: randomize(20) },
      2.0 => { prediction: 0, actual: randomize(20.5) },
      3.0 => { prediction: randomize(40), actual: randomize(10) },
      4.0 => { prediction: randomize(50), actual: randomize(50) } }
  end

  def ugly_series_points
    { 1.0 => { prediction: randomize(190), actual: randomize(20) },
      2.0 => { prediction: randomize(103.5), actual: randomize(30) },
      3.0 => { prediction: randomize(403), actual: randomize(200) },
      4.0 => { prediction: randomize(10), actual: randomize(500) } }
  end

  def negative_series_points
    { 1.0 => { prediction: randomize(-190), actual: randomize(-20) },
      2.0 => { prediction: randomize(-103.5), actual: randomize(-30) },
      3.0 => { prediction: randomize(-403), actual: randomize(-200) },
      4.0 => { prediction: randomize(-10), actual: randomize(-500) } }
  end

  def mixed_series_points
    { 1.0 => { prediction: randomize(190), actual: randomize(-20), other: randomize(50) },
      2.0 => { prediction: randomize(-103.5), actual: randomize(30), other: randomize(-200) },
      3.0 => { prediction: nil, actual: randomize(-200), other: randomize(-500) },
      4.0 => { prediction: randomize(403), actual: randomize(200), other: randomize(100) },
      5.0 => { prediction: randomize(400), actual: randomize(100), other: randomize(50) },
      7.0 => { prediction: randomize(-10), actual: randomize(-500), other: randomize(-40) } }
  end

  def categories
    { 'apples' => randomize(2), 'oranges' => nil, 'bananas' => randomize(1), 'grapes' => randomize(4),
      'pears' => randomize(5) }
  end

  def ugly_categories
    { 'apples' => randomize(200), 'oranges' => randomize(3), 'bananas' => randomize(103.3), 'grapes' => randomize(400),
      'pears' => randomize(50) }
  end

  def negative_categories
    { 'apples' => randomize(-2), 'oranges' => randomize(-3), 'bananas' => randomize(-103.3), 'grapes' => randomize(-4),
      'pears' => randomize(-5) }
  end

  def mixed_categories
    { 'apples' => randomize(20), 'oranges' => randomize(30), 'bananas' => randomize(-103.3), 'grapes' => nil,
      'pears' => randomize(50) }
  end

  def series_categories
    { 'apples' => { prediction: randomize(10), actual: randomize(20), ideal: randomize(30.5) },
      'oranges' => { prediction: 0, actual: randomize(20.5), ideal: randomize(10.5) },
      'bananas' => { prediction: randomize(40), actual: nil, ideal: randomize(2.5) },
      'grapes' => { prediction: randomize(50), actual: randomize(50), ideal: randomize(3.5) } }
  end

  def ugly_series_categories
    { 'apples' => { prediction: randomize(190), actual: randomize(20) },
      'oranges' => { prediction: randomize(103.5), actual: randomize(30) },
      'bananas' => { prediction: randomize(403), actual: randomize(200) },
      'grapes' => { prediction: randomize(10), actual: randomize(500) } }
  end

  def negative_series_categories
    { 'apples' => { prediction: randomize(-190), actual: randomize(-20), ideal: randomize(-30.5) },
      'oranges' => { prediction: randomize(-103.5), actual: nil, ideal: randomize(-10) },
      'bananas' => { prediction: randomize(-403), actual: randomize(-200), ideal: randomize(-20) },
      'grapes' => { prediction: randomize(-10), actual: randomize(-100), ideal: randomize(-20) } }
  end

  def mixed_series_categories
    { 'apples' => { prediction: randomize(190.0), actual: randomize(-20.0), ideal: randomize(30.5) },
      'oranges' => { prediction: randomize(-103.5), actual: randomize(30), ideal: randomize(10) },
      'bananas' => { prediction: nil, actual: randomize(100), ideal: randomize(-20) },
      'grapes' => { prediction: randomize(-10), actual: randomize(-100), ideal: randomize(20) } }
  end

  private

  def randomize(value)
    Random.rand(value.abs.to_f) * (value <=> 0)
  end
end
