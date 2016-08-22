require 'rails_helper'

feature 'View list of questions', %q{
	In order to find answer for created question
	as an user
	i want to be able to view list of questions
}  do
  let(:user) { create(:user) }	
  let!(:questions) { create_list(:question, 5) }
  scenario 'Authenticated user view list of questions' do
  	sign_in(user)
  	visit questions_path

  	questions.each do |question|
  		expect(page).to have_content question.title
  	end
  	expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user view list of questions' do
  	visit questions_path

  	questions.each do |question|
  	  expect(page).to have_content question.title
  	end
  	expect(current_path).to eq questions_path
  end
end