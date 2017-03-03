require_relative 'acceptance_helper'

feature 'User', %q{
  In order to be find an question/comment/answer/user
  I want to be able to search
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:comment) { create(:comment, commentable: question) }

  before do
    index
    visit questions_path
  end

  scenario 'try to find question', js: true do
    make_search('question', question.title)
    expect(page).to have_content question.title
  end

  scenario 'try to find answer', js: true do
    make_search('answer', answer.body)
    expect(page).to have_content answer.body
  end

  scenario 'try to find comment', js: true do
    make_search('comment', comment.body)
    expect(page).to have_content comment.body
  end

  scenario 'try to find user', js: true do
    make_search('user', user.email)
    expect(page).to have_content user.email
  end

  scenario 'try to find all', js: true do
    make_search('all', comment.body)
    expect(page).to have_content comment.body
  end

  scenario 'no result', js: true do
    make_search('all', 'asdasdasd')
    expect(page).to have_content 'No results'
  end

  private 

  def make_search(type, text)
    select type, from: 'search_type'
    fill_in 'Search', with: text
    click_on 'Search'
  end
end
