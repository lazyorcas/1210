# frozen_string_literal: true

class User::Invitation::PublicHash < PublicHash
  default_scope { where(hashable_type: "User::Invitation") }

  def user_invitation
    hashable
  end
end
