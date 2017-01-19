require_relative 'acceptance_helper'

feature 'Best answer', %q{
  In order to choose a best answer
  Author of question
  is able to choose a best asnwer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    describe 'Author' do

      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'sees a Best answer link' do
        expect(page).to have_link 'Mark as best'
      end

      scenario 'choose a best answer', js: true do
        click_on 'Mark as best'
        expect(page).to_not have_link 'Mark as best'
        expect(page).to have_content 'IT IS THE BEST ANSWER!'
      end

      describe 'few answers' do
        given!(:answer2) { create(:answer, question: question, user: user) }

        scenario 'best answer is on top', js: true do
          visit question_path(question) # lля того, что бы отобразился второй вопрос, т.к. мы его создаем руками
          page.all('.mark-best-answer-link')[1].click
          visit question_path(question) # перезаходим на страницу, чтобы список перестроился
          within all('.answer_body')[0] do
            expect(page).to have_content 'IT IS THE BEST ANSWER!'
          end
        end
      end
    end

    scenario 'tryes to choose best answer for not his question' do
      user2 = create(:user)
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best'
    end
  end

end