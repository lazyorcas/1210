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
    -> { where(is_accepted: true) },
    class_name: "Idea::Option::Invitation",
    as: :inviter
  has_many :upvoters, through: :upvotes, source: :invitee, source_type: "User"

  after_create :invite_idea_user_and_voters

  def idea
    pollable
  end

  def upvote_percent
    upvotes.count * 100 / invitations.count
  end

  private

  def invite_idea_user_and_voters
    ([idea.user] + idea.voters).each do |user|
      Idea::Option::Invitation.create(
        inviter: self,
        invitee: user,
        is_accepted: user == originator || nil,
      )
    end
  end
end
