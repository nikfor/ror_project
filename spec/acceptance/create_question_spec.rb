require 'rails_helper'

feature 'Create question', %q{
	In order to get answer from community
	As signed in user
	i want to be able to ask question
} do
  	
  let (:user) { create(:user) }
  scenario 'Authenticated user creates question' do    
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text'
    click_on 'Create'
    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content "Your question successfully created."
    
    
  end

  scenario 'Non-authenticated user tries to creat question' do
    visit questions_path
    click_on 'Ask question' 
    expect(page).to have_content 'You need to sign in or sign up before continuing.' 
  end

end