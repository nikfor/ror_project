class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :new]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash[:success] = "Your answer successfully created."
      redirect_to @question
    else
      flash[:error] = @answer.errors.full_messages
      @answers = @question.answers.reload
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = Question.find(@answer.question_id)
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:success] = "Your answer has been successfully deleted!"
    else
       flash[:error] = "You cannot delete answers written by others."
    end
    redirect_to @question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
