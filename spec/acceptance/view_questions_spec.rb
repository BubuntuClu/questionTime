require 'rails_helper'

feature 'View questions', %q{
  In order to read the questions
  As an user
  I want to be able to view questions
} do
  scenario 'User views question' do
    create_list(:question, 2)
    visit questions_path
    expect(page).to have_css('h2.title', count: 2)
  end
end