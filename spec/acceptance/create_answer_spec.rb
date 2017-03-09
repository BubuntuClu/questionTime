require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to give an answer
  As an user
  I want to be able to write an asnwer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    title = question.title    
    give_an_answer
    expect(current_path).to eq question_path(question)
    
    within '.answers' do
      expect(page).to have_content 'Test answer text'  
    end
  end

  scenario 'Authenticated user creates answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    title = question.title
    give_an_invalid_answer
    expect(page).to_not have_content '123'
    expect(page).to have_content "Body is too short (minimum is 10 characters)"
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit question_path(question)
    expect(page).to_not have_button 'Give an answer'
  end

  context "multiple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Text testx answer'
          click_on 'Add file'
        end
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
      end

      Capybara.using_session('quest') do
        within '.answers' do
          expect(page).to have_content 'Text testx answer'
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
        end
      end
    end
  end

  private

  def give_an_answer
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer text'
      click_on 'Give an answer'
    end
  end

  def give_an_invalid_answer
    within '.new_answer' do
      fill_in 'Body', with: '123'
      click_on 'Give an answer'
    end
  end
end
