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
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :upvotes,
    -> { accepted },
    class_name: "Idea::Option::Invitation",
    as: :inviter
  has_many :upvoters, through: :upvotes, source: :invitee, source_type: "User"

  after_commit :notify_of_new_option, on: :create
  after_create :invite_idea_organizer_and_voters

  def idea
    pollable
  end

  def upvote_percent
    upvotes.count * 100 / invitations.count
  end

  def notify_of_new_option
    recipients = User.where(id: idea.voters + [idea.organizer] - [originator]).without_push_subscription

    if recipients.present?
      Idea::OptionMailer
        .with(idea_option: self, recipients: recipients.map(&:email))
        .new_option_notification
        .deliver_later
    end
  end

  private

  def invite_idea_organizer_and_voters
    ([idea.organizer] + idea.voters).each do |user|
      Idea::Option::Invitation.create(
        inviter: self,
        invitee: user,
        is_accepted: user == originator || nil,
      )
    end
  end
end
