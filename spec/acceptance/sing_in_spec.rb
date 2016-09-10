require_relative 'acceptance_helper'

feature 'User sing in', %q{
  In order to be able to ask question
  as an User
  i want to be able to signe in
} do
  let (:user) { create(:user) }

  scenario 'Registered user ty to sing in' do
  
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
    #save_and_open_page
  end

  scenario 'Non-registered user try to sign in' do
  	visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
  
end