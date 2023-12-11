# frozen_string_literal: true

class PhotosController < SocialNetworkController
  skip_before_action :track_ahoy_visit

  def show
    load_photo
    authorize!
    build_variant if @photo.blob.content_type != "image/webp"
    send_data(@photo.blob.download, type: @photo.blob.content_type, disposition: "inline")
  end

  private

  def authorize!
    if @photo.record_type == "Memory"
      memory_scope.find(@photo.record_id)
    elsif @photo.record_type == "User"
      user_scope.find(@photo.record_id)
    elsif @photo.record_type == "Thing"
      thing_scope.find(@photo.record_id)
    end
  end

  def load_photo
    @photo = ActiveStorage::Attachment.find(params[:id])
  end

  def build_variant
    @photo = @photo.variant(:webp).processed.image
  end

  def memory_scope
    Memory.where(meetup_id: current_user.organized_meetups + current_user.accepted_meetups)
  end

  def user_scope
    User.where(id: [current_user] + current_user.friends)
  end

  def thing_scope
    Thing.where(owner: [nil, current_user] + current_user.friends)
  end
end
