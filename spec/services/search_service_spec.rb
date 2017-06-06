require 'rails_helper'
require_relative '../acceptance/acceptance_helper'

RSpec.describe Search do
  
  it 'calls search in all' do
    request = "qwe@qwe.qwe"
    escaped_request = ThinkingSphinx::Query.escape(request)
    expect(ThinkingSphinx).to receive(:search).with(escaped_request).and_call_original
    Search.run('all', request, nil)
  end

  it 'calls search in question' do
    request = "question"
    escaped_request = ThinkingSphinx::Query.escape(request)
    expect(Question).to receive(:search).with(escaped_request).and_call_original
    Search.run('question', request, nil)
  end

  it 'calls search in answer' do
    request = "answer"
    escaped_request = ThinkingSphinx::Query.escape(request)
    expect(Answer).to receive(:search).with(escaped_request).and_call_original
    Search.run('answer', request, nil)
  end

  it 'calls search in comment' do
    request = "comment"
    escaped_request = ThinkingSphinx::Query.escape(request)
    expect(Comment).to receive(:search).with(escaped_request).and_call_original
    Search.run('comment', request, nil)
  end

  it 'calls search in user' do
    request = "user@user.ru"
    escaped_request = ThinkingSphinx::Query.escape(request)
    expect(User).to receive(:search).with(escaped_request).and_call_original
    Search.run('user', request, nil)
  end

  it 'return empty array', type: :sphinx do
    question = create(:question)
    index
    expect(Search.run('question', 'afasf',nil)).to eq []
  end
end
