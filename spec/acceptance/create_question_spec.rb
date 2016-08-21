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
    
    
  end

  scenario 'Non-authenticated user tries to creat question' do
    visit questions_path
    click_on 'Ask question' 
    #save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.' 
  end

end