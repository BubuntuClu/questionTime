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
end
