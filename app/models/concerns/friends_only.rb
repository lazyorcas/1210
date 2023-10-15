# frozen_string_literal: true

module FriendsOnly
  extend ActiveSupport::Concern

  included do
    before_commit :limit_invitees_to_main_user_friends, if: -> { invitees.present? }, on: [:create, :update]
    before_create :set_invitees_to_main_user_friends, if: -> { invitees.empty? }
  end

  private

  def limit_invitees_to_main_user_friends
    self.invitees &= main_user.friends
  end

  def set_invitees_to_main_user_friends
    self.invitees = main_user.friends
  end

  def main_user
    raise NotImplementedError
  end
end
