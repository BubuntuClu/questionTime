require_relative 'acceptance_helper'

feature 'delete files from question', %q{
  In order to change my illustration of question
  As an questions' author
  I' like to be able to remove files
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text testx question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
  end

  scenario 'author delete file' do
    click_on 'Delete attach'
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'not author tryes to delete file' do
    click_on 'Sign out'
    sign_in(user2)
    visit "/questions/1"
    expect(page).to_not have_link 'Delete attach'
  end
end