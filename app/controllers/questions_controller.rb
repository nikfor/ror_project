class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  include Voted
  
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end
  

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = "Your question successfully created."
      redirect_to  @question
    else
      flash.now[:alert] = @question.errors.full_messages.to_s
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:notice] = "Your question successfully updated."
      redirect_to @question
    else
      flash.now[:alert] = @question.errors.full_messages
      render :edit
    end
  end

  def destroy
    if current_user.id == @question.user_id 
      @question.destroy
      redirect_to questions_path
    else
      redirect_to question_path(@question)
    end
    
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end
end