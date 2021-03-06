require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }
  
  scenario 'Authenticated user creates qiestion' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    within '.new_question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text testx question'
      click_on 'Create'
    end
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Text testx question'
  end

  scenario 'Authenticated user creates invalid qiestion' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test'
    fill_in 'Body', with: 'Text'
    click_on 'Create'
    expect(page).to have_content 'Question could not be created.'
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end

  context "multiple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('quest') do
        user2 = create(:user)
        sign_in(user2)
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Text testx question'
        click_on 'Create'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text testx question'
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Vote up'
        expect(page).to have_content 'Vote down'
      end
    end
  end

end
