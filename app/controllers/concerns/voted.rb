module Voted
  extend ActiveSupport::Concern
  
  included do
    before_action :load_votable, only: [:like, :dislike, :change_vote, :cancel_vote]
    respond_to :json, only: [:like, :dislike, :change_vote, :cancel_vote]
  end

  def like
    if current_user.can_vote?(@votable)
      respond_with(@votable.vote(current_user, 1), template: 'votes/vote.json.jbuilder')
    else
      render json: '{"error": "You cannot vote"}', status: :unprocessable_entity
    end
  end

  def dislike
    if current_user.can_vote?(@votable)
      respond_with(@votable.vote(current_user, -1), template: 'votes/vote.json.jbuilder')
    else
      render json: '{"error": "You cannot vote"}', status: :unprocessable_entity
    end
  end

  def change_vote
    if !current_user.author_of?(@votable) && current_user.voted?(@votable)
      respond_with(@votable.change_vote_value(current_user), template: 'votes/vote.json.jbuilder')
    else
      render json: '{"error": "You cannot vote"}', status: :unprocessable_entity
    end
  end

  def cancel_vote
    if !current_user.author_of?(@votable) && current_user.voted?(@votable)
      respond_with(@votable.cancel_votable(current_user), template: 'votes/vote.json.jbuilder')
    else
      render json: '{"error": "You cannot vote"}', status: :unprocessable_entity
    end
  end

  private

   def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end