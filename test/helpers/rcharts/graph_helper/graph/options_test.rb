# frozen_string_literal: true

require 'test_helper'

module RCharts
  module GraphHelper
    module Graph
      class OptionsTest < ActiveSupport::TestCase
        setup do
          @defaults = { x: { 0 => { values_method: :keys } }, y: { 0 => { values_method: :values } } }
        end

        test 'merges defaults with normalized options when options empty' do
          assert_equal @defaults, Options.new([], {}).to_h
        end

        test 'merges defaults with normalized array values in options' do
          assert_equal @defaults.deep_merge(a: { 0 => 'foo', 1 => 'bar' }),
                       Options.new([], { a: %w[foo bar] }).to_h
        end

        test 'merges defaults with already normalized hash values in options' do
          assert_equal @defaults.deep_merge(a: { 0 => 'foo', 1 => 'bar' }),
                       Options.new([], { a: { 0 => 'foo', 1 => 'bar' } }).to_h
        end

        test 'normalizes scalar values in options' do
          assert_equal @defaults.deep_merge(a: { 0 => 'foo' }),
                       Options.new([], { a: 'foo' }).to_h
        end

        test 'applies block to resulting hash' do
          @defaults.deep_merge({ a: { 0 => 'foo', 1 => 'bar' } })
                   .to_h { |key, value| [key.to_s.upcase, value.to_s.upcase] }
                   .then do |expected|
                     assert_equal(expected, Options.new([], { a: { 0 => 'foo', 1 => 'bar' } })
                                                   .to_h { |key, value| [key.to_s.upcase, value.to_s.upcase] })
          end
        end
      end
    end
  end
end
