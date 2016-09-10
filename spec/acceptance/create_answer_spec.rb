require_relative 'acceptance_helper'

feature 'Create answer', %q{
	In order to help others 
	as user
	i want to be able to create answer for question
} do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  scenario 'Authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer_body', with: 'Test answer body'
    click_on 'Create answer'

    expect(page).to have_content 'Test answer body'
    expect(current_path).to eq question_path(question)
  end

  scenario 'User creates invalid answer', js: true do
  	sign_in(user)

  	visit question_path(question)
  	fill_in 'answer_body', with: nil
    click_on 'Create answer'

    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq question_path(question)
  end

   scenario 'Non-authenticated user ties to create answer to question' do
    visit question_path(question)
    expect(page).to_not have_content('Create answer')
  end
end