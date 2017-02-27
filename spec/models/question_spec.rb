require 'rails_helper'

describe Question do

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(10).is_at_most(100) }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'concern' do
    it_behaves_like 'votable'
    it_behaves_like 'attachmentable'
    it_behaves_like 'commentable'
  end

  describe 'subscribe' do
    let (:user) { create(:user) }
    let (:user2) { create(:user) }
    let!(:question) { create(:question, user:user) }

    it 'user subscribed' do
      question.subscribe_user(user2)
      expect(question.subscribers.count).to eq(2)
    end

    it 'user unsubscribed' do
      question.unsubscribe_user(user)
      expect(question.subscribers.count).to eq(0)
    end
  end
end
