# frozen_string_literal: true

require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  root "home#index"

  passwordless_for :users
  mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new

  resources :users, only: [:new, :create, :show]
  namespace :user do
    resources :invitations, only: [:index, :create, :update], path: "/friends"
    get "/settings", to: "settings#index"
  end

  resources :meetups
  namespace :meetup do
    resources :invitations, only: [:update]
  end
  resources :past_meetups, only: [:new, :create]

  resources :memories, except: [:new, :create, :edit, :destroy]

  resources :ideas
  namespace :idea do
    resources :invitations, only: [:update]
    namespace :option do
      resources :invitations, only: [:update]
    end
  end
  scope module: "idea", path: "/idea/:idea_id", as: "idea" do
    resources :options, only: [:new, :create]
  end

  resources :push_subscriptions, only: [:create]

  resources :photos, only: [:show]

  get "/help/meetups", to: "help#meetups"
  get "/help/friends", to: "help#friends"

  # redirects
  get "/:date/meetups", to: redirect("/meetups", status: 301)
end
