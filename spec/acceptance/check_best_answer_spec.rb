require_relative 'acceptance_helper'

feature 'Check best answer', %q{
  In order to help other find answer faster
  as an question author
  i want to be able to choose the best answer
} do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user, best: false) } 
  let!(:other_answer) { create(:answer, question: question, user: other_user, best: false) }

  describe 'Non-authenticated user tries' do
    scenario 'Unauthenticated user tries to set the best answer' do 
      visit question_path(question)
      
      within('.answers') do
        expect(page).to have_no_link 'Best answer'
      end
    end
  end

  describe 'Author choose' do
    before do
      sign_in(user)
      visit question_path(question)
      within("#answer-#{answer.id}") do
        click_on 'Best answer'
      end
    end

    scenario 'Author of question can choose the best answer', js: true do
      within('.answers') do
        expect(page).to have_css('.best-answer', count: 1)
        expect(page).to have_css("li#answer-#{answer.id}.best-answer")
        expect(question.answers).to start_with answer
      end
      
    end

    scenario 'Author can choose another answer as the best', js: true do
      within("#answer-#{other_answer.id}") do
        click_on 'Best answer'
      end

      within('.answers') do
        expect(page).to have_css('.best-answer', count: 1)
        expect(page).to have_no_css("li#answer-#{answer.id}.best-answer")
        expect(question.answers).to start_with other_answer
        expect(page).to have_css("li#answer-#{other_answer.id}.best-answer")
      end
    end
  end

  describe 'Not author tries' do
    scenario 'Another user tries to choose the best answer' do
      sign_in(other_user)
      visit question_path(question)
    
      within('.answers') do
        expect(page).to have_no_link 'Best answer'
      end
    end
  end
end