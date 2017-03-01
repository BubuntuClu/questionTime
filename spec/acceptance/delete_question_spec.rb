require_relative 'acceptance_helper'

feature 'Delete question', %q{
  User wants to delete the question
} do 
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete question' do
    sign_in(user)
    visit questions_path
    click_on 'Delete question'
    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user trying to delete not his question' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user trying to delete not his question' do
    create(:question, user: user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
  
end
