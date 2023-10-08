# frozen_string_literal: true

class PushNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(push_subscription:, title:, body:)
    WebPush.payload_send(
      message: JSON.generate({
        title: title,
        body: body,
      }),
      endpoint: push_subscription.endpoint,
      p256dh: push_subscription.p256dh_key,
      auth: push_subscription.auth_key,
      vapid: {
        subject: root_url,
        public_key: Rails.application.credentials[:vapid][:public_key],
        private_key: Rails.application.credentials[:vapid][:private_key],
      },
    )
  end
end
