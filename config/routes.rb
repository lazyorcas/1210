# frozen_string_literal: true

require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  root "home#index"
  get "/download", to: "home#download", as: "download"

  passwordless_for :users
  mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new

  resources :users, only: [:new, :create, :show]
  namespace :user do
    resources :invitations, only: [:create, :update]
  end

  scope path: "/me", as: "current_user" do
    get "/friends", to: "current_user#friends", as: "friends"
    get "/profile", to: "current_user#profile", as: "profile"
    get "/edit_city", to: "current_user#edit_city", as: "edit_city"
    get "/edit_avatar", to: "current_user#edit_avatar", as: "edit_avatar"
    patch "/", to: "current_user#update", as: "update"
  end

  resources :availabilities, only: [:index]
  scope module: "availability_group", path: "/availability_group/:date/:time_of_day", as: "availability_group" do
    resources :things, only: [:index, :show]
  end

  scope module: "current_user", path: "/me", as: "current_user" do
    resources :availabilities, only: [:index, :create, :destroy]
  end

  resources :meetups
  namespace :meetup do
    resources :invitations, only: [:update]
  end
  scope module: "meetup", path: "/meetup/:meetup_id", as: "meetup" do
    resources :comments, only: [:index, :create]
  end
  resources :past_meetups, only: [:new, :create]

  resources :memories, only: [:index, :show, :update]

  resources :things, only: [:index]
  scope module: "thing", path: "/thing/:thing_id", as: "thing" do
    resources :invitations, only: [:index, :create, :update]
  end

  resources :ideas
  namespace :idea do
    resources :invitations, only: [:update]
    namespace :option do
      resources :invitations, only: [:update]
    end
  end
  scope module: "idea", path: "/idea/:idea_id", as: "idea" do
    resources :options, only: [:new, :create]
    resources :comments, only: [:index, :create]
  end

  resources :push_subscriptions, only: [:create]

  resources :photos, only: [:show]

  scope path: "/help", as: "help" do
    get "/meetups", to: "help#meetups"
    get "/ideas", to: "help#ideas"
    get "/memories", to: "help#memories"
    get "/things", to: "help#things"
  end

  namespace :admin do
    resources :things
  end
end
