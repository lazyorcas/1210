# frozen_string_literal: true

class Meetup::CommentsController < ApplicationController
  before_action :require_user!

  def index
    load_meetup
    load_meetup_comments
    order_meetup_comments
  end

  def create
    load_meetup
    @meetup_comment = Meetup::Comment.new(meetup_comment_params)
    @meetup_comment.commentable = @meetup
    @meetup_comment.author = current_user

    if @meetup_comment.save
      turbo_stream
    end
  end

  private

  def load_meetup
    @meetup = meetup_scope.find(params[:meetup_id])
  end

  def load_meetup_comments
    @meetup_comments = @meetup.comments
  end

  def order_meetup_comments
    @meetup_comments = @meetup_comments.order!(:created_at)
  end

  def meetup_scope
    Meetup.where(id: current_user.organized_meetup_ids + current_user.invited_meetup_ids)
  end

  def meetup_comment_params
    params.require(:meetup_comment).permit(:body)
  end
end
