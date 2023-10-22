# frozen_string_literal: true

require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  root "home#index"

  get "/install", to: "home#install", as: :install

  passwordless_for :users
  mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new

  resources :users, only: [:new, :create, :show]
  namespace :user do
    resources :invitations, only: [:index, :create, :update], path: "/friends"
  end

  resources :meetups
  namespace :meetup do
    resources :invitations, only: [:update]
  end
  resources :past_meetups, only: [:new, :create]

  resources :memories, except: [:new, :create, :edit, :destroy]
  scope module: "memory", path: "/memory/:memory_id", as: "memory" do
    resources :photos, only: [:show]
  end

  resources :ideas
  namespace :idea do
    resources :invitations, only: [:update]
  end

  resources :push_subscriptions, only: [:create]

  # redirects
  get "/:date/meetups", to: redirect("/meetups", status: 301)
end
