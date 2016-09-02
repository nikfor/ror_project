require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to give right information
  as an author of Answer
  i want to be able to edit my answer
} do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user) } 
  let!(:other_answer) { create(:answer, question: question, user: other_user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    
    within('.answers') do
      expect(page).to_not have_link 'Edit'
    end  
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author tries to edit his answer', js: true do
      within("#answer-#{answer.id}") do
        expect(page).to have_link 'Edit'
        click_on 'Edit'
        fill_in 'answer_body', with: 'edited answer'
        click_on 'Update answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Another user tries to edit answer' do
            
      within("#answer-#{other_answer.id}") do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end