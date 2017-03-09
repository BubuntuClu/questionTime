require_relative 'acceptance_helper'

feature 'Create comment', %q{
  In order to give an comment
  As an user
  I want to be able to write an comment
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates comment for question', js: true do
    sign_in(user)
    visit question_path(question)
    title = question.title
    give_an_question_comment
    expect(current_path).to eq question_path(question)
    
    within '.question_comments' do
      expect(page).to have_content 'This is comment for question'  
    end
  end

  scenario 'Authenticated user create comment for answer', js: true do
    sign_in(user)
    visit question_path(question)
    title = question.title
    give_an_answer
    sleep(1)
    visit question_path(question)
    give_an_answer_comment
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'This is comment for answer'  
    end
  end

  scenario 'Non-authenticated user try to creates comment' do
    visit question_path(question)
    expect(page).to_not have_link "Comment question"
    expect(page).to_not have_link "Comment answer"
  end

  context "multiple sessions" do
    scenario "question's comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        give_an_question_comment
      end

      Capybara.using_session('quest') do
        within '.question_comments' do
          expect(page).to have_content 'This is comment for question'  
        end
      end
    end
  end

  private

  def give_an_question_comment
    within '.question_comments' do
      fill_in 'Body', with: 'This is comment for question'
      click_on 'Comment question'
    end
  end

  def give_an_answer
    within '.new_answer' do
      fill_in 'Body', with: 'Test answer text'
      click_on 'Give an answer'
    end
  end

  def give_an_answer_comment
    within '.answer_elem' do
      # within '#new_comment' do
        fill_in 'Body', with: 'This is comment for answer'
        click_on 'Comment answer'
      # end
    end
  end
end
