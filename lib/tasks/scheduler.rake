# frozen_string_literal: true

task create_memories: :environment do
  puts "Creating memories for yesterday meetups..."

  Meetup
    .where(date: Time.zone.yesterday)
    .left_joins(:memory)
    .where(memory: { id: nil })
    .joins(:attendees)
    .group("meetups.id")
    .having("COUNT(users.id) > 1")
    .each do |meetup|
      puts "Creating memory for meetup #{meetup.id}..."

      memory = meetup.create_memory

      if memory.persisted?
        puts "Memory created!"
      else
        puts "Memory not created!", memory.errors.full_messages
      end
    end
end

task remind_user_availabilities: :environment do
  puts "Reminding users to mark their availabilities"

  PushSubscription.all.each do |push_subscription|
    puts "Reminding user #{push_subscription.user_id}..."

    PushNotificationJob.perform_later(
      push_subscription: push_subscription,
      title: "👋 Are you free today?",
      body: "Mark your free time if you wanna meet up with your friends today.",
    )
  end
end
