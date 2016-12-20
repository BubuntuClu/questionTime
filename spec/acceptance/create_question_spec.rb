require 'rails_helper'

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
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text testx question'
    click_on 'Create'
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Text testx question'
  end

  scenario 'Authenticated user creates qiestion' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test'
    fill_in 'Body', with: 'Text'
    click_on 'Create'
    expect(page).to have_content 'Not valid data.'
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit questions_path
    click_on 'Ask question'  
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end