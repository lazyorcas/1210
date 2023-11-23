# frozen_string_literal: true

class IdeasController < SocialNetworkController
  layout :resolve_layout

  after_action :track_saw_ideas, only: [:index]

  def index
    if params[:inactive]
      ahoy.track("visited_inactive_ideas")
    else
      ahoy.track("visited_ideas")
    end

    load_ideas
    @should_filter = @ideas.count >= 5
    filter_ideas if @should_filter
    order_ideas

    ahoy.track("saw_no_ideas") if @ideas.empty?
  end

  def new
    @idea = Idea.new
    @idea.thing_id = params[:thing_id]
    @idea.title = @idea.thing&.title
    assign_current_user_to_idea_organizer
  end

  def create
    @idea = Idea.new(idea_params)
    assign_current_user_to_idea_organizer

    if @idea.save
      turbo_stream
    end
  end

  def show
    load_idea
  end

  def edit
    load_current_user_idea
  end

  def update
    load_current_user_idea
    @idea.attributes = idea_params

    if @idea.save
      if @idea.saved_change_to_status? && @idea.polling?
        redirect_to(idea_path(@idea))
      else
        turbo_stream
      end
    end
  end

  def destroy
    load_current_user_idea
    if @idea.soft_delete
      turbo_stream
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "main_tab"
    else
      false
    end
  end

  def track_saw_ideas
    invited_ideas = @ideas & current_user.invited_ideas

    invited_ideas.each do |idea|
      unless idea.seen_invitees.exists?(current_user.id)
        ahoy.track(idea.seen_event_name, idea.seen_event_properties)
      end
    end
  end

  def load_current_user_idea
    @idea = current_user.ideas.find(params[:id])
  end

  def load_idea
    @idea = idea_scope.find(params[:id])
  end

  def assign_current_user_to_idea_organizer
    @idea.organizer = current_user
  end

  def load_ideas
    @ideas = idea_scope
  end

  def filter_ideas
    if params[:inactive]
      filter_by_inactive_ideas
    else
      filter_by_active_ideas
    end
  end

  def filter_by_active_ideas
    @ideas = @ideas.where.not(id: @ideas.inactive)
  end

  def filter_by_inactive_ideas
    @ideas = @ideas.inactive
  end

  def order_ideas
    @ideas.order!(last_activity_at: :desc)
  end

  def idea_scope
    Idea
      .looking_for_voters
      .where(id: current_user.idea_ids + current_user.invited_idea_ids)
      .or(
        Idea
        .polling
        .where(id: current_user.idea_ids + current_user.voting_idea_ids),
      )
  end

  def idea_params
    params.require(:idea).permit(:title, :description, :status, :thing_id, invitee_ids: [])
  end
end
