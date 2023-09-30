# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  passwordless_for :users

  namespace :users do
    resources :invitations, only: [:index, :create, :update], path: "/friends"
  end
  resources :users, only: [:new, :create, :show]

  resources :meetups, only: [:edit, :update, :destroy]
  resources :meetup_attendances, only: [:create, :update]

  scope path: ":date" do
    get "/plans", to: "plans#index", as: "plans"

    resources :meetups, only: [:index, :new, :create]
  end
end
