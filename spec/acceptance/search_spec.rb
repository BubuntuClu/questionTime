require_relative 'acceptance_helper'

feature 'User', %q{
  In order to be find an question/comment/answer/user
  I want to be able to search
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:comment) { create(:comment, commentable: question) }

    # before do
    #   index
    #   visit questions_path
    # end

    before(:all) do
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start
      ThinkingSphinx::Test.index
      sleep(0.25)
      
    end

    scenario 'try to find question' do
      visit questions_path
      select 'question', from: 'search_type'
      fill_in 'Search', with: question.title

      click_on 'Search'
      expect(page).to have_content question.title
    end

    scenario 'try to find answer' do
      visit questions_path
      select 'answer', from: 'search_type'
      fill_in 'Search', with: answer.body
      
      click_on 'Search'
      expect(page).to have_content answer.body
    end

    scenario 'try to find comment' do
      visit questions_path
      select 'comment', from: 'search_type'
      fill_in 'Search', with: comment.body
      click_on 'Search'
      expect(page).to have_content comment.body
    end

    scenario 'try to find user' do
      select 'user', from: 'search_type'
      fill_in 'Search', with: user.email
      
      click_on 'Search'
      expect(page).to have_content user.email
    end

    scenario 'no result' do
      select 'all', from: 'search_type'
      fill_in 'Search', with: 'asdasdasd'
      
      click_on 'Search'
      expect(page).to have_content 'No results'
    end

    after(:all) do
      ThinkingSphinx::Test.stop
    end
end
