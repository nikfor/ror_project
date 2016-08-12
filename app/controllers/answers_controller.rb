class AnswersController < ApplicationController
	before_action :load_question, only: [:create]

	def create
		@question.answers << Answer.new(answer_params)
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
