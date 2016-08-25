require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }
  
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'GET #new' do
  	before { get :new, params: { question_id: question } }
  	it 'creates a new Answer' do
  	  expect(assigns(:answer)).to be_a_new(Answer)
  	end

  	it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
    end

      it 'answer has author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it 'rederects to show question with answers' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders new' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end    
  end

  describe 'DELETE #destroy' do
    context 'author deletes his answer' do
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'rederects to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path( answer.question_id )
      end
    end

    context 'not author delete' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, question: question, user: other_user) }
      it 'delete other answer' do
        expect { delete :destroy, params: { id: other_answer } }.to_not change(Answer, :count)
      end
    end
  end
end

