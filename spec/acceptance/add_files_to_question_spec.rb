require_relative 'acceptance_helper'

feature 'add files to question', %q{
  In order to illustrate my question
  As an questions' author
  I' like to be able to attach files
} do
  
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'user adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text testx question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'user adds a few files when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text testx question'
    click_on 'Add file'
    within page.all('.nested-fields')[0] do 
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    within page.all('.nested-fields')[1] do 
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'
    expect(page).to have_content 'Test question'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end