# frozen_string_literal: true

require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  root "home#index"

  get "/install", to: "home#install", as: :install

  passwordless_for :users
  mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new

  namespace :users do
    resources :invitations, only: [:index, :create, :update], path: "/friends"
  end
  resources :users, only: [:new, :create, :show]

  namespace :meetups do
    resources :invitations, only: [:update]
  end
  resources :meetups, only: [:show, :edit, :update, :destroy]

  scope module: "memories", path: "/memories/:memory_id", as: "memories" do
    resources :photos, only: [:show]
  end
  resources :memories, except: [:new, :create, :edit, :destroy]

  namespace :ideas do
    resources :invitations, only: [:update]
  end
  resources :ideas

  resources :push_subscriptions, only: [:create]

  scope path: ":date" do
    resources :meetups, only: [:index, :new, :create]
  end
end
