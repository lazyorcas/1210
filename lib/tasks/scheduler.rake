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

task notify_of_new_meetups: :environment do
  puts "Notifying of new meetups..."

  Meetup
    .upcoming
    .where(created_at: 1.hour.ago..Time.zone.now)
    .each do |meetup|
      puts "Notifying of meetup #{meetup.id}..."

      MeetupMailer
        .with(meetup: meetup, recipients: meetup.invitees.without_push_subscription)
        .new_meetup_notification.deliver_later
    end
end

task notify_of_new_ideas: :environment do
  puts "Notifying of new ideas..."

  Idea
    .where(created_at: 1.hour.ago..Time.zone.now)
    .each do |idea|
      puts "Notifying of idea #{idea.id}..."

      IdeaMailer
        .with(idea: idea, recipients: idea.invitees.without_push_subscription)
        .new_idea_notification.deliver_later
    end
end

task notify_of_new_idea_options: :environment do
  puts "Notifying of new idea options..."

  Idea
    .joins(:options)
    .where(pollable_options: { created_at: 1.hour.ago..Time.zone.now })
    .group("ideas.id")
    .each do |idea|
      puts "Notifying of idea options for idea #{idea.id}..."

      Idea::OptionMailer
        .with(idea: idea, recipients: idea.voters.without_push_subscription)
        .new_option_notification.deliver_later
    end
end
