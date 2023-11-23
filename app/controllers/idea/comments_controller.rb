# frozen_string_literal: true

class Idea::CommentsController < SocialNetworkController
  def index
    load_idea
    load_idea_comments
    order_idea_comments
  end

  def create
    load_idea
    @idea_comment = Idea::Comment.new(idea_comment_params)
    @idea_comment.commentable = @idea
    @idea_comment.author = current_user

    if @idea_comment.save
      turbo_stream
    end
  end

  private

  def load_idea
    @idea = idea_scope.find(params[:idea_id])
  end

  def load_idea_comments
    @idea_comments = @idea.comments
  end

  def order_idea_comments
    @idea_comments.order!(:created_at)
  end

  def idea_scope
    Idea.where(id: current_user.ideas + current_user.invited_ideas)
  end

  def idea_comment_params
    params.require(:idea_comment).permit(:body)
  end
end
