# frozen_string_literal: true

class Memories::PhotosController < ApplicationController
  before_action :require_user!
  skip_before_action :track_ahoy_visit

  def show
    load_memory
    load_photo
    build_variant
    send_data(@photo.blob.download, type: @photo.blob.content_type, disposition: "inline")
  end

  private

  def load_memory
    @memory = memory_scope.find(params[:memory_id])
  end

  def load_photo
    @photo = @memory.photos.find(params[:id])
  end

  def build_variant
    @photo = @photo.variant(:webp).processed.image
  end

  def memory_scope
    Memory.where(meetup_id: current_user.organized_meetup_ids + current_user.accepted_meetup_ids)
  end
end
