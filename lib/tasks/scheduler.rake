# frozen_string_literal: true

task create_memories: :environment do
  puts "Creating memories for yesterday meetups..."

  Meetup
    .where(date: Time.zone.yesterday)
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
