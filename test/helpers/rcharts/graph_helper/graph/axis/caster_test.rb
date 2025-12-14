# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class CasterTest < ActiveSupport::TestCase
          setup do
            @rails_release = Time.iso8601('2004-07-24T20:43:00Z')
                                 .in_time_zone(ActiveSupport::TimeZone['Central Time (US & Canada)'])
            @everest_summit_arrival = Time.iso8601('1953-05-29T11:30:00+05:45')
            @millennium = Time.iso8601('2000-01-01T00:00:00Z')
            @cervantes_death_date_time = DateTime.iso8601('1616-04-23T18:30:00-00:15', Date::ITALY)
            @shakespeare_death_date_time = DateTime.iso8601('1616-04-23T14:30:00-00:07', Date::ENGLAND)
            @cervantes_death_date = Date.iso8601('1616-04-23', Date::ITALY)
            @shakespeare_death_date = Date.iso8601('1616-04-23', Date::ENGLAND)
            @random_value = BigDecimal(Math::PI)
          end

          test 'casting preserves time with zone year' do
            assert_equal @rails_release.year, Caster.new(@rails_release).casting(&:next).year
          end

          test 'casting preserves time with zone offset' do
            assert_equal @rails_release.utc_offset, Caster.new(@rails_release).casting(&:next).utc_offset
          end

          test 'casting allows time with zone changes' do
            assert_not_equal @rails_release, Caster.new(@rails_release).casting(&:next)
          end

          test 'casting preserves time year' do
            assert_equal @everest_summit_arrival.year, Caster.new(@everest_summit_arrival).casting(&:next).year
          end

          test 'casting preserves time zone' do
            assert_equal @millennium.utc_offset,
                         Caster.new(@millennium).casting(&:next).utc_offset
          end

          test 'casting preserves time offset' do
            assert_equal @everest_summit_arrival.utc_offset,
                         Caster.new(@everest_summit_arrival).casting(&:next).utc_offset
          end

          test 'casting allows time changes' do
            assert_not_equal @everest_summit_arrival.seconds_since_midnight,
                             Caster.new(@everest_summit_arrival).casting(&:next).seconds_since_midnight
          end

          test 'casting preserves date time year' do
            assert_equal @cervantes_death_date_time.year,
                         Caster.new(@cervantes_death_date_time).casting(&-> { it + 1.5 }).year
          end

          test 'casting preserves date time offset' do
            assert_equal @cervantes_death_date_time.utc_offset,
                         Caster.new(@cervantes_death_date_time).casting(&-> { it + 1.5 }).utc_offset
          end

          test 'casting preserves date time zone' do
            assert_equal @cervantes_death_date_time.zone,
                         Caster.new(@cervantes_death_date_time).casting(&-> { it + 1.5 }).zone
          end

          test 'casting allows date time changes' do
            assert_not_equal @cervantes_death_date_time.seconds_since_midnight,
                             Caster.new(@cervantes_death_date_time).casting(&-> { it + 1.5 }).seconds_since_midnight
          end

          test 'casting preserves date time origins' do
            assert_not_equal Caster.new(@shakespeare_death_date_time).casting(&-> { it + 1.5 }).wday,
                             Caster.new(@cervantes_death_date_time).casting(&-> { it + 1.5 }).wday
          end

          test 'casting preserves date year' do
            assert_equal @cervantes_death_date.year, Caster.new(@cervantes_death_date).casting(&-> { it + 1.5 }).year
          end

          test 'casting allows date changes' do
            assert_not_equal @cervantes_death_date.yday,
                             Caster.new(@cervantes_death_date).casting(&-> { it + 1.5 }).yday
          end

          test 'casting preserves date origins' do
            assert_not_equal Caster.new(@shakespeare_death_date).casting(&-> { it + 1.5 }).wday,
                             Caster.new(@cervantes_death_date).casting(&-> { it + 1.5 }).wday
          end

          test 'casting preserves other values' do
            assert_equal @random_value, Caster.new(@random_value).casting(&:itself)
          end
        end
      end
    end
  end
end
