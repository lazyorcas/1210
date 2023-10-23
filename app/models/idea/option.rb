# frozen_string_literal: true

class Idea::Option < Pollable::Option
  default_scope { where(pollable_type: "Idea") }

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

  after_create :create_accepted_invitation_for_idea_user
  after_create :invite_idea_voters

  def idea
    pollable
  end

  private

  def create_accepted_invitation_for_idea_user
    Idea::Option::Invitation.create(
      inviter: self,
      invitee: idea.user,
      is_accepted: true,
    )
  end

  def invite_idea_voters
    idea.voters.each do |user|
      Idea::Option::Invitation.create(
        inviter: self,
        invitee: user,
      )
    end
  end
end
