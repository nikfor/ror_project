class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :new]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if !@answer.save
      @answers = @question.answers.reload
    end
  end

  def edit
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.id == @answer.user_id 
      @answer.update(answer_params)
    end
  end
  
  def best
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.question.user_id
      @answer.check_best
      @answer.reload
    else
      @best_answer_error = "You cannot choose best answer."
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.destroy
      flash.now[:notice] = "Your answer has been successfully deleted!"
    else
       @destroy_answer_error = "You cannot delete answers written by others."
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
