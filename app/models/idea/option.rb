# frozen_string_literal: true

class Idea::Option < Pollable::Option
  default_scope { where(pollable_type: "Idea") }

  attr_accessor :originator

  scope :sorted_by_upvotes, -> {
    left_joins(:upvotes)
      .group(:id)
      .order("COUNT(invitations.id) DESC")
  }

  has_many :invitations,
    class_name: "Idea::Option::Invitation",
    as: :inviter
  has_many :voters, through: :invitations, source: :invitee, source_type: "User"

  has_many :upvotes,
    -> { where(is_accepted: true) },
    class_name: "Idea::Option::Invitation",
    as: :inviter
  has_many :upvoters, through: :upvotes, source: :invitee, source_type: "User"

  after_create :create_accepted_invitation_for_originator, if: -> { originator.present? }
  after_create :invite_voters
  after_create :notify_voters_to_vote

  def idea
    pollable
  end

  private

  def notify_voters_to_vote
    other_option = idea.options
      .where(created_at: 5.minutes.ago..Time.zone.now)
      .where.not(id: id).first

    if other_option.nil?
      PushSubscription.where(user: voters - [originator]).each do |push_subscription|
        PushNotificationJob.perform_later(
          push_subscription: push_subscription,
          title: "[Idea] #{title}",
          body: "😎 New option added. Check it out!",
        )
      end

      Idea::OptionMailer.with(idea_option: self).new_option_notification.deliver_later
    end
  end

  def create_accepted_invitation_for_originator
    Idea::Option::Invitation.create(
      inviter: self,
      invitee: originator,
      is_accepted: true,
    )
  end

  def invite_voters
    (idea.voters + [idea.user]).uniq.each do |user|
      Idea::Option::Invitation.create(
        inviter: self,
        invitee: user,
      )
    end
  end
end
