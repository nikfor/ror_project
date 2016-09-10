require_relative 'acceptance_helper'

feature 'View question with answers', %q{
	In order to help others 
	as user
	i want to be able to create answer for question
} do
  let(:user) { create(:user) }
  let(:answer_user) { create(:user) }
  let(:answer) { create(:answer, user: answer_user) }
  let(:question) { create(:question, user: user) }
  before { question.answers.push(answer) }
  scenario 'Authenticated user view question with answers' do
    sign_in(user)
    visit question_path(question)
    #save_and_open_page
    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question text'
    expect(page).to have_content 'MyText'
  end

  scenario 'Non-authenticated user ties to create answer to question' do
    visit question_path(question)
    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question text'
    expect(page).to have_content 'MyText'
  end
end