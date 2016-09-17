require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustarate my question
  as an question's author
  i'd like to be able to attach files
} do
  let!(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User deletes file' do
    
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end
end