# frozen_string_literal: true

class PushSubscriptionsController < ApplicationController
  protect_from_forgery except: :create

  def create
    @push_subscription = PushSubscription.new(push_subscription_params)
    @push_subscription.user = current_user

    if @push_subscription.save
      head(:created)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def push_subscription_params
    params
      .require(:push_subscription)
      .permit(:endpoint, :p256dh_key, :auth_key, :expiration_time)
  end
end
