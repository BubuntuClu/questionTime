require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix my misstake
  As an author of Question
  I want to edit my question
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    describe 'Author' do

      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'sees a Edit question link of question' do
        expect(page).to have_link 'Edit question'
      end

      scenario 'tryes to edit his question', js: true do
        click_on 'Edit question'
          fill_in 'Edit question', with: 'edited question'
          click_on 'Save question'
          within '#title_question' do
            expect(page).to_not have_content question.body  
            expect(page).to have_content 'edited question'
            expect(page).to_not have_selector 'textarea'
          end
      end
    end

    scenario 'tryes to edit not his question' do
      user2 = create(:user)
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end