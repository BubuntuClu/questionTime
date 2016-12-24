require 'rails_helper'

feature 'View questions', %q{
  In order to read the questions
  As an user
  I want to be able to view questions
} do
  scenario 'User views question' do
    questions = create_list(:question, 2)
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'User can views question and answer on it' do
    user = create(:user)
    sign_in(user)
    question = create(:question, user: user)
    answers = create_list(:answer, 2, question: question)
    click_on 'Sign out'
    visit questions_path(question)
    click_on 'View question'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
        save_and_open_page
  end

end