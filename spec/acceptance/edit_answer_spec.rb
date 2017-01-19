require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix my misstake
  As an author of Answer
  I want to edit my answer
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees a Edit link of answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tryes to edit his answer', js: true do
      # TODO do this spec
      click_on 'Edit'
      within '.answers' do
        within '.answer_body' do
          fill_in 'Edit answer', with: 'edited answer'
          click_on 'Save'
          expect(page).to_not have_content answer.body  
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
      
    end

    scenario 'tryes to edit not his answer' do
      user2 = create(:user)
      answer2 = create(:answer, user: user2, question: question)
      visit question_path(question)
      expect(page).to have_selector(".answer_body", count: 2)
      expect(page).to have_selector(".edit-answer-link", count: 1)
    end
  end
end