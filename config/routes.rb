# frozen_string_literal: true

require 'sidekiq_unique_jobs/web'

Rails.application.routes.draw do
  root to: 'clinics#index'

  mount Sidekiq::Web, at: '/sidekiq'

  constraints Subdomain.webhooks do
    post '/:integration' => 'webhooks#receive', as: 'webhooks_receive'
  end

  resources :clinics, only: %i[index show]
end
