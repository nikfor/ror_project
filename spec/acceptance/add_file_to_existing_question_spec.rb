require_relative 'acceptance_helper'

feature 'Edit files in question', %q{
  In order to correct file in question
  as an author of question
  i'd like to be able to change file
} do  
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: question) }

  scenario 'author change file in question', js: true do
    sign_in(user)
    visit edit_question_path(question)


    within("#file-#{attachment.id}") do
      expect(page).to have_link(attachment.file.identifier) 
      click_on 'Delete file'
    end  

    expect(page).to have_no_link(attachment.file.identifier) 
    click_on 'add file'
    fill_in 'question_title', with: 'edited question title'
    fill_in 'question_body', with: 'edited question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content question.body
    expect(page).to have_content 'edited question title'
    expect(page).to have_content 'edited question'
    
    within('.attachments') do 
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb' 
    end
  end

end