require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer
  As an user
  I want to be able to write an asnwer
} do
  given(:user) { create(:user) }
  given (:question) { create(:question) }
  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit questions_path(question)
    title = question.title
    give_an_answer

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content title
    expect(page).to have_content 'Test answer text'
  end

  scenario 'Authenticated user create answer with invalid data' do
    sign_in(user)
    visit questions_path(question)
    title = question.title
    give_an_invalid_answer
    expect(page).to have_content 'Not valid data.'
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit questions_path(question)
    give_an_answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  private

  def give_an_answer
    click_on 'View question'
    fill_in 'Body', with: 'Test answer text'
    click_on 'Give an answer'
  end

  def give_an_invalid_answer
    click_on 'View question'
    fill_in 'Body', with: '123'
    click_on 'Give an answer'
  end
end