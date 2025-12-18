# frozen_string_literal: true

class SamplesController < ApplicationController
  def show
    @sample = Sample.new(sample_params)
  end

  private

  def sample_params
    params.fetch(:sample, {}).permit(:pulses)
  end
end
