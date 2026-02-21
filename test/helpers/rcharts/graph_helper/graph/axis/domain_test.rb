# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class Axis
        class DomainTest < ActiveSupport::TestCase
          test 'exact mode returns raw minimum and maximum for integers' do
            assert_domain_bounds 7, 23, Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :exact)
          end

          test 'exact mode returns raw minimum and maximum for floats' do
            assert_domain_bounds 7.9, 23.1, Domain.new(minimum: 7.9, maximum: 23.1, tick_interval: 2.5, mode: :exact)
          end

          test 'exact mode returns raw minimum and maximum for dates' do
            assert_domain_bounds Date.new(2026, 2, 21),
                                 Date.new(2031, 2, 21),
                                 Domain.new(minimum: Date.new(2026, 2, 21),
                                            maximum: Date.new(2031, 2, 21),
                                            tick_interval: 86_400, mode: :exact)
          end

          test 'exact mode returns raw minimum and maximum for times' do
            assert_domain_bounds Time.new(2025, 1, 1, 12, 0, 0), # rubocop:disable Rails/TimeZone
                                 Time.new(2025, 1, 2, 12, 0, 0), # rubocop:disable Rails/TimeZone
                                 Domain.new(minimum: Time.new(2025, 1, 1, 12, 0, 0), # rubocop:disable Rails/TimeZone
                                            maximum: Time.new(2025, 1, 2, 12, 0, 0), # rubocop:disable Rails/TimeZone
                                            tick_interval: 7200, mode: :exact)
          end

          test 'rounded mode returns adjusted minimum and maximum for integers' do
            assert_domain_bounds 5, 25, Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :rounded)
          end

          test 'rounded mode returns adjusted minimum and maximum for floats' do
            assert_domain_bounds 7.5, 25.0, Domain.new(minimum: 7.9, maximum: 23.1, tick_interval: 2.5, mode: :rounded)
          end

          test 'rounded mode returns adjusted minimum and maximum for dates' do
            assert_domain_includes Date.new(2026, 2, 21),
                                   Date.new(2031, 2, 21),
                                   Domain.new(minimum: Date.new(2026, 2, 21),
                                              maximum: Date.new(2031, 2, 21),
                                              tick_interval: 86_400 * 365, mode: :rounded)
          end

          test 'rounded mode returns adjusted minimum and maximum for times' do
            assert_domain_includes Time.new(2025, 1, 1, 12, 30, 0), # rubocop:disable Rails/TimeZone
                                   Time.new(2025, 1, 2, 14, 30, 0), # rubocop:disable Rails/TimeZone
                                   Domain.new(minimum: Time.new(2025, 1, 1, 12, 30, 0), # rubocop:disable Rails/TimeZone
                                              maximum: Time.new(2025, 1, 2, 14, 30, 0), # rubocop:disable Rails/TimeZone
                                              tick_interval: 7200, mode: :rounded)
          end

          test 'returns true if exact for exact mode' do
            assert_predicate Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :exact), :exact?
            assert_not_predicate Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :rounded), :exact?
          end

          test ' returns true if rounded for rounded mode' do
            assert_predicate Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :rounded), :rounded?
            assert_not_predicate Domain.new(minimum: 7, maximum: 23, tick_interval: 5, mode: :exact), :rounded?
          end

          test 'handles single value in exact mode' do
            assert_domain_bounds 10, 10, Domain.new(minimum: 10, maximum: 10, tick_interval: 0, mode: :exact)
          end

          test 'handles single value in rounded mode' do
            assert_domain_bounds 10, 10, Domain.new(minimum: 10, maximum: 10, tick_interval: 0, mode: :rounded)
          end

          test 'handles zero tick interval in exact mode' do
            assert_domain_bounds 10, 20, Domain.new(minimum: 10, maximum: 20, tick_interval: 0, mode: :exact)
          end

          private

          def assert_domain_includes(minimum, maximum, domain)
            assert_operator domain.domain_minimum, :<=, minimum
            assert_operator domain.domain_maximum, :>=, maximum
          end

          def assert_domain_bounds(minimum, maximum, domain)
            case minimum
            when Float then assert_in_delta minimum, domain.domain_minimum

            else assert_equal minimum, domain.domain_minimum
            end
            case maximum
            when Float then assert_in_delta maximum, domain.domain_maximum

            else assert_equal maximum, domain.domain_maximum
            end
          end
        end
      end
    end
  end
end
