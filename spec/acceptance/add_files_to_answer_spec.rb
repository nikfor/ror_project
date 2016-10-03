require_relative 'acceptance_helper'

feature 'Add file to answer', %q{
  In order to illustrate my answer
  as author of answer
  i want to be able to attach file
} do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answers question', js: true do
    fill_in 'answer_body', with: 'Test answer body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    end
  end
end