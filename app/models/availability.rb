# frozen_string_literal: true

class Availability < ApplicationRecord
  include Dateful

  default_scope { where("date >= ?", Time.zone.today) }

  enum time_of_day: { breakfast: 0, morning: 1, lunch: 2, afternoon: 3, dinner: 4, evening: 5 }

  belongs_to :user

  validates_presence_of :date, :time_of_day
  validates_uniqueness_of :user_id, scope: [:date, :time_of_day]

  after_commit :notify_friends, on: [:create]

  def user_friends_in_availbility_group
    user
      .friends_in_the_same_city
      .joins(:availabilities)
      .where(
        availabilities: {
          date: date,
          time_of_day: time_of_day,
        },
      )
  end

  def notify_friends
    PushSubscription.where(user: user_friends_in_availbility_group).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "#{time_of_day_emoji} #{relative_to_today(date).capitalize} #{time_of_day}",
        body: "#{user.name} might be free to meet up.",
      )
    end
  end

  def time_of_day_emoji
    case time_of_day
    when "breakfast"
      "🥞"
    when "morning"
      "🏙️"
    when "lunch"
      "🍔"
    when "afternoon"
      "🌆"
    when "dinner"
      "🍕"
    when "evening"
      "🌃"
    end
  end
end
