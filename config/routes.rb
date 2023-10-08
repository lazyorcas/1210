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

  namespace :ideas do
    resources :invitations, only: [:update]
  end
  resources :ideas, except: [:destroy]

  resources :push_subscriptions, only: [:create]

  scope path: ":date" do
    resources :meetups, only: [:index, :new, :create]
  end
end
