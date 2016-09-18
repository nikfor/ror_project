require_relative 'acceptance_helper'

feature 'Edit files in answer', %q{
  In order to correct file in answer
  as an author of answer
  i'd like to be able to change file
} do   
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: answer) }

  scenario 'author change file in answer', js: true do
    sign_in(user)
    visit question_path(question)


    within("#answer-#{answer.id}") do
      expect(page).to have_link(attachment.file.identifier) 
      
      within '.answer_files' do
        click_on 'Delete file'
      end  

      expect(page).to have_no_link(attachment.file.identifier) 
      expect(page).to have_link 'Edit'
      click_on 'Edit'
      fill_in 'answer_body', with: 'edited answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Update answer'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end