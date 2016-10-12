class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :best, :destroy]
  before_action :load_question, only: [:create, :new]
  before_action :load_user

  include Voted
  
  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      respond_to do |format|
        format.js { publish(@answer, :create)}
      end
    else
      @answers = @question.answers.reload
    end
  end

  def edit
  end

  def update
    @question = @answer.question
    if current_user.id == @answer.user_id 
      @answer.update(answer_params)
      respond_to do |format|
        format.js { publish(@answer, :update)}
      end
    end
  end
  
  def best
    if current_user.id == @answer.question.user_id
      @answer.best!
      
    else
      @best_answer_error = "You cannot choose best answer."
    end
  end

  def destroy
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.destroy
      respond_to do |format|
        format.js { publish(@answer, :delete)}
      end
      flash.now[:notice] = "Your answer has been successfully deleted!"
    else
       @destroy_answer_error = "You cannot delete answers written by others."
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_user
    if current_user.present?
      gon.user = current_user.id
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def publish(answer, method)
    PrivatePub.publish_to "/questions/#{@answer.question_id}/answers",
                          answer: answer.to_builder, 
                          method: method
  end

end
