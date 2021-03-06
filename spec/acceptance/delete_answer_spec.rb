require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to delete a wrong answer
  As an authenticated user
  I want to be able to delete an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author delete answer', js: true do
    sign_in(user)
    answer = create(:answer, user: user, question: question)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user trying to delete not his answer' do
    user2 = create(:user)
    sign_in(user2)
    answer = create(:answer, user: user, question: question)
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user trying to delete not his answer' do
    create(:answer, user: user, question: question)
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

end
