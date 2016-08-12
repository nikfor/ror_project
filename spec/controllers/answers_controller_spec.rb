require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
	    expect { post :create, params:{question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'rederects to show question with answers' do
	    post :create, params:{question_id: question, answer: attributes_for(:answer) }
    	expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params:{question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'rederects to show question with answers' do
        post :create, params:{question_id: question, answer: attributes_for(:invalid_answer) }
	    expect(response).to redirect_to question
      end
    end    
  end
end

