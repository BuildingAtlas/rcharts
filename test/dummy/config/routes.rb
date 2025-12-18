# frozen_string_literal: true

Rails.application.routes.draw do
  resource :samples, only: :show

  root to: 'samples#show'
end
