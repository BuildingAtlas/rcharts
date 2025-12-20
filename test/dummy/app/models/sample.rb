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

  def daily_timeseries
    (0..30).to_a.to_h { [it.days.from_now.to_date, randomize(100)] }
  end

  def monthly_timeseries
    (0..12).to_a.to_h { [it.months.from_now.to_date, randomize(1000)] }
  end

  def yearly_timeseries
    (0..5).to_a.to_h { [it.years.from_now.to_date, randomize(10_000)] }
  end

  def comparison_timeseries
    (0..10).to_a.to_h { [it.days.from_now.to_date, { current: randomize(100), previous: randomize(80) }] }
  end

  def sparse_timeseries
    (0..20).to_a.to_h { [it.days.from_now.to_date, (it % 5).zero? ? nil : randomize(50)] }
  end

  def categorical_data
    { 'Apples' => randomize(50), 'Oranges' => randomize(40), 'Bananas' => randomize(60), 'Grapes' => randomize(30) }
  end

  def multi_series_categorical
    { 'Q1' => { sales: randomize(100), profit: randomize(20) },
      'Q2' => { sales: randomize(120), profit: randomize(25) },
      'Q3' => { sales: randomize(110), profit: randomize(15) },
      'Q4' => { sales: randomize(150), profit: randomize(40) } }
  end

  def mixed_sign_data
    { 'A' => randomize(50), 'B' => randomize(-30), 'C' => randomize(20), 'D' => randomize(-10) }
  end

  def points
    (0..10).to_a.to_h { [it.to_f, randomize(100)] }
  end

  def distribution_data
    (0..20).to_a.index_with { randomize(it * 5) }
  end

  private

  def randomize(value)
    Random.rand(value.abs.to_f) * (value <=> 0)
  end
end
