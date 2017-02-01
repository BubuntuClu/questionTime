require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to vote for good answer
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to vote for question' do
    visit question_path(question)
    expect(page).to_not have_link 'Vote up'
    expect(page).to_not have_link 'Vote down'
  end

  describe 'Authenticated user' do
    describe 'Author' do

      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'Author cant see votes links for his question' do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to_not have_link 'Unvote'
      end
    end  

    describe 'Not Author' do

      before do
        user2 = create(:user)
        sign_in user2
        visit question_path(question)
      end

      scenario 'Not author votes up for not his question', js: true do
        click_on 'Vote up'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Unvote'
        expect(page).to have_text 'Rating: 1'
      end

      scenario 'Not author votes down for not his question', js: true do
        click_on 'Vote down'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Unvote'
        expect(page).to have_text 'Rating: -1'
      end

      scenario 'Not author votes and then unvotes for not his question', js: true do
        click_on 'Vote down'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Unvote'
        expect(page).to have_text 'Rating: -1'

        click_on 'Unvote'
        expect(page).to have_link 'Vote up'
        expect(page).to have_link 'Vote down'
        expect(page).to_not have_link 'Unvote'
        expect(page).to have_text 'Rating: 0'
      end
    end 
  end
end
