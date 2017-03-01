require_relative 'acceptance_helper'

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
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end

  describe 'subscribe block' do 
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }

    scenario 'Author of question can unsubscribe on question', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Unsubscribe'
      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end

    scenario 'Any authorizated user can subscribe and unsubscribe on question', js: true do
      user2 = create(:user)
      sign_in(user2)
      visit question_path(question)

      click_on 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
      expect(page).to_not have_content 'Subscribe'

      click_on 'Unsubscribe'
      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end

    scenario 'Any not-authorizated user cannt subscribe and unsubscribe on question' do
      visit question_path(question)

      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

end
