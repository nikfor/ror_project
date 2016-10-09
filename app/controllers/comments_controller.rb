class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]

  def create
    @comment = @commentable.comments.create(comment_params)
  end

  def update
    if current_user.id == @comment.user_id
      @comment.update(comment_params)
    end
  end

  def destroy
    if current_user.id == @comment.user_id
      @comment.destroy
      flash.now[:notice] = "Your comment has been successfully deleted!"
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

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
