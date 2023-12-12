# frozen_string_literal: true

require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  root "home#index"
  get "/download", to: "home#download", as: "download"

  passwordless_for :users
  mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new

  resources :users, only: [:new, :create]
  namespace :user do
    resources :invitations, only: [:new]
    namespace :invitation do
      resources :public_hashes, only: [:show]
    end
  end

  scope path: "/me", as: "current_user" do
    get "/friends", to: "current_user#friends", as: "friends"
    get "/edit_city", to: "current_user#edit_city", as: "edit_city"
    get "/edit_avatar", to: "current_user#edit_avatar", as: "edit_avatar"
    get "/", to: "current_user#index"
    patch "/", to: "current_user#update", as: "update"
  end

  scope module: "current_user", path: "/me", as: "current_user" do
    resources :things, except: [:show]
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

  get "/things/interesting", to: "things#interesting", as: "interesting_things"
  get "/things/uninteresting", to: "things#uninteresting", as: "uninteresting_things"
  get "/things/filter", to: "things#filter", as: "filter_things"
  resources :things, only: [:index, :show]
  scope module: "thing", path: "/thing/:thing_id", as: "thing" do
    resources :invitations, only: [:create, :show, :update]

    scope module: "availability", path: "/availability/:availability_id", as: "availability" do
      resources :invitations, only: [:create, :update]
    end
  end

  scope module: "city", path: "/city/:city_name", as: "city" do
    resources :things, only: [:index]
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

  namespace :admin do
    resources :things
  end
end
