class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]

  def create
    @comment = @commentable.comments.create(comment_params)
    respond_to do |format|
      format.js { publish(@comment, :create); head :ok }
    end
  end

  def update
    if current_user.id == @comment.user_id
       respond_to do |format|
        format.js { publish(@comment, :update) }
      end
    end
  end

  def destroy
    if current_user.id == @comment.user_id
      @comment.destroy
      flash.now[:notice] = "Your comment has been successfully deleted!"
      respond_to do |format|
        format.js { publish(@comment, :delete) }
      end
    else
       @destroy_comment_error = "You cannot delete comments written by others."
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def load_commentable
    @commentable = commentable_type.classify.constantize.find(params["#{commentable_type}_id"])
  end

  def commentable_type
    params[:commentable_type]
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def send_url(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end

  def publish(comment, method)
    PrivatePub.publish_to "/questions/#{ send_url(comment.commentable) }/comments", 
                          comment: comment.to_builder, 
                          method: method
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
