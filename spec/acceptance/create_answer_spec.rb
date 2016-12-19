require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer
  As an user
  I want to be able to write an asnwer
} do
  given (:question) { create(:question) }
  scenario 'User creates answer' do
    visit questions_path(question)
    title = question.title
    click_on 'View question'
    fill_in 'Body', with: 'This is test answer for question'
    click_on 'Give an answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content title
  end
end