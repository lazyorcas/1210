# frozen_string_literal: true

module FriendsOnly
  extend ActiveSupport::Concern

  included do
    before_commit :limit_invitees_to_organizer_friends, if: -> { invitees.present? }, on: [:create, :update]
    before_create :set_invitees_to_organizer_friends, if: -> { !invitees.present? }
  end

  private

  def limit_invitees_to_organizer_friends
    self.invitees &= organizer.friends
  end

  def set_invitees_to_organizer_friends
    self.invitees = organizer.friends
  end

  def main_user
    raise NotImplementedError
  end
end
