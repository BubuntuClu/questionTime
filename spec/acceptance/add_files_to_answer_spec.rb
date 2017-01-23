require_relative 'acceptance_helper'

feature 'add files to answers', %q{
  In order to illustrate my answer
  As an answer's author
  I' like to be able to attach files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds file when asks answer', js: true do
    fill_in 'Body', with: 'Text testx answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Give an answer'

    within '.answers' do
      expect(page).to have_content 'Text testx answer'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'user adds a few files when asks answer', js: true do
    fill_in 'Body', with: 'Text testx answer'
    click_on 'Add file'
    within page.all('.nested-fields')[0] do 
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    within page.all('.nested-fields')[1] do 
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Give an answer'
    expect(page).to have_content 'Text testx answer'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    save_and_open_page
  end
end