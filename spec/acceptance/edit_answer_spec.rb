require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix ma misstake
  As an author of Answer
  I want to edit my answer
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees a Edit link of answer', js: true do
      save_and_open_page
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tryes to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body  
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      
    end

    scenario 'tryes to edit not his answer'
  end
end