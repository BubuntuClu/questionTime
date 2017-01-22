require_relative 'acceptance_helper'

feature 'add files to answers', %q{
  In order to illustrate my asnswer
  As an asnwer's author
  I' like to be able to attach files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds file when asks answer' do
    fill_in 'Body', with: 'Text testx answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Text testx answer'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end