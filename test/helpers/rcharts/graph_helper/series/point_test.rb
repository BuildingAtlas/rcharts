# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Series
      class PointTest < ActiveSupport::TestCase
        module Assertions
          extend ActiveSupport::Concern

          included do
            private

            def assert_between(middle, upper, lower)
              case middle
              when Point
                assert middle.x.between?(*[upper.x, lower.x].minmax)
                assert middle.y.between?(*[upper.y, lower.y].minmax)
              else
                assert middle.between?(upper, lower)
              end
            end
          end
        end

        module Extensions
          extend ActiveSupport::Concern

          included do
            Point.class_eval do
              def shift(axis, shift = 1)
                self + Point.new(axis == :x ? shift : 0, axis == :y ? shift : 0)
              end
            end
          end
        end

        include Assertions
        include Extensions

        setup do
          @point = Point.new(1, 2)
          @previous_point = Point.new(0, 1)
          @next_point = Point.new(3, 4)
        end

        test 'returns string representation' do
          assert_equal '1,2', @point.to_s
        end

        test 'adds two points' do
          assert_equal Point.new(3, 4), @point + Point.new(2, 2)
        end

        test 'subtracts two points' do
          assert_equal Point.new(-1, 0), @point - Point.new(2, 2)
        end

        test 'calculates control point with default smoothing and no reverse' do
          assert_instance_of Point, @point.control(@previous_point, @next_point)
          assert_predicate @point.control(@previous_point, @next_point), :complete?
        end

        test 'calculates control point with reverse set to true' do
          assert_instance_of Point, @point.control(@next_point, @previous_point, reverse: true)
          assert_predicate @point.control(@next_point, @previous_point, reverse: true), :complete?
        end

        test 'calculates control point with custom smoothing factor' do
          assert_instance_of Point, @point.control(@previous_point, @next_point, smoothing: 2.0)
          assert_predicate @point.control(@previous_point, @next_point, smoothing: 2.0), :complete?
        end

        test 'clamps control point within expected range' do
          assert_between @point.control(@previous_point, @next_point), @previous_point, @next_point
        end

        test 'returns true if point is incomplete' do
          assert_predicate @point.class.new(nil, 2), :incomplete?
          assert_predicate @point.class.new(1, nil), :incomplete?
        end

        test 'returns false if point is complete' do
          assert_not_predicate @point, :incomplete?
        end

        test 'returns true if point is complete' do
          assert_predicate Point.new(5, 3), :complete?
        end

        test 'returns false if point is incomplete' do
          assert_not_predicate Point.new(nil, 3), :complete?
          assert_not_predicate Point.new(5, nil), :complete?
        end

        test 'zero smoothing returns same point' do
          assert_equal @point, @point.control(@previous_point, @next_point, smoothing: 0.0)
        end

        test 'huge smoothing clamps to next point when reverse is false' do
          assert_equal @next_point, @point.control(@previous_point, @next_point, smoothing: 1e6)
        end

        test 'huge smoothing clamps to previous point when reverse is true' do
          assert_equal @previous_point, @point.control(@previous_point, @next_point, smoothing: 1e6, reverse: true)
        end

        test 'degenerate neighbor vector yields same point' do
          assert_equal @point, @point.control(Point.new(0, 0), Point.new(0, 0))
        end

        test 'peak extremum on Y yields no Y offset' do
          assert_equal @point.y, @point.control(@point.shift(:y, -1).shift(:x, -1), @point.shift(:y, -1).shift(:x)).y
        end

        test 'trough extremum on Y yields no Y offset' do
          assert_equal @point.y, @point.control(@point.shift(:y).shift(:x, -1), @point.shift(:y).shift(:x)).y
        end

        test 'flat horizontal segment keeps Y unchanged and clamps X toward limit' do
          @point.control(@point + Point.new(-1, 0), @point.shift(:x), smoothing: 1.0) => { x:, y: }

          assert_equal @point.y, y
          assert_equal @point.shift(:x).x, x
        end

        test 'pure vertical segment keeps X unchanged and Y within bounds' do
          @point.control(@point.shift(:y, -1), @point.shift(:y, 2)) => { x:, y: }

          assert_equal @point.x, x
          assert_between y, @point.y, @point.shift(:y, 2).y
        end

        test 'forward and backward controls head in opposite directions' do
          assert_between @point.control(@previous_point, @next_point), @point, @next_point
          assert_between @point.control(@previous_point, @next_point, reverse: true), @previous_point, @point
        end

        test 'forward and backward vectors have opposite directions' do
          @point.control(@previous_point, @next_point) - @point => { x: forward_x, y: forward_y }
          @point.control(@previous_point, @next_point, reverse: true) - @point => { x: backward_x, y: backward_y }

          assert_operator (forward_x * backward_x) + (forward_y * backward_y), :<=, 0
        end

        test 'clamping works with mixed axis directions' do
          assert_between @point.control(@point.shift(:x).shift(:y, -1), @point.shift(:x, -3).shift(:y, 4)),
                         @point,
                         @point.shift(:x, -3).shift(:y, 4)
        end

        test 'negative coordinates still produce a valid clamped control point' do
          assert_between @point.control(@point.shift(:x, -3).shift(:y, 2), @point.shift(:x).shift(:y, -3),
                                        smoothing: 0.5),
                         @point,
                         @point.shift(:x).shift(:y, -3)
        end

        test 'current point equal to a neighbor keeps control within bounds' do
          assert_between @point.control(@point, @point.shift(:x).shift(:y), smoothing: 2.0),
                         @point,
                         @point.shift(:x).shift(:y)
        end
      end
    end
  end
end
