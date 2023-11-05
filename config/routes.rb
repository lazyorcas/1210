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
  end

  scope path: "/me", as: "current_user" do
    get "/settings", to: "current_user#settings", as: "settings"
    get "/edit", to: "current_user#edit", as: "edit"
    patch "/", to: "current_user#update", as: "update"
  end

  resources :meetups
  namespace :meetup do
    resources :invitations, only: [:update]
  end
  scope module: "meetup", path: "/meetup/:meetup_id", as: "meetup" do
    resources :comments, only: [:index, :create]
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
  get "/help/ideas", to: "help#ideas"
  get "/help/memories", to: "help#memories"
  get "/help/friends", to: "help#friends"

  get "/download", to: "home#download", as: "download"

  # redirects
  get "/:date/meetups", to: redirect("/meetups", status: 301)
end
