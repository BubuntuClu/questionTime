require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to give an answer
  As an user
  I want to be able to write an asnwer
} do
  given(:user) { create(:user) }
  given (:question) { create(:question) }
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

  scenario 'Authenticated user create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    title = question.title
    give_an_invalid_answer
    expect(page).to_not have_content '123'
    expect(page).to have_content "Body is too short (minimum is 10 characters)"
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit question_path(question)
    give_an_answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  private

  def give_an_answer
    fill_in 'Body', with: 'Test answer text'
    click_on 'Give an answer'
  end

  def give_an_invalid_answer
    fill_in 'Body', with: '123'
    click_on 'Give an answer'
  end
end