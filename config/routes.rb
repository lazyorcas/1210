# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  passwordless_for :users

  resources :users, only: [:new, :create, :show]
  get "/friends", to: "users#friends", as: "friends"

  resources :invites, only: [:create]
  get "/invites/:id/accept", to: "invites#accept", as: "accept_invite"

  resources :meetups, only: [:edit, :update, :destroy]
  resources :meetup_attendances, only: [:create, :update]

  scope path: ":date" do
    get "/plans", to: "plans#index", as: "plans"

    resources :meetups, only: [:index, :new, :create]
  end
end
