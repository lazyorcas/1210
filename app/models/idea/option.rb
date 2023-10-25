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

  after_create :invite_idea_voters

  def idea
    pollable
  end

  private

  def invite_idea_voters
    ([idea.user] + idea.voters).each do |user|
      Idea::Option::Invitation.create(
        inviter: self,
        invitee: user,
      )
    end
  end
end
