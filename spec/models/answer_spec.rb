require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'best answer' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'set asnwer as a best' do
      answer.set_best_answer
      expect(answer.reload).to be_best
    end

    it 'set another asnwer as a best' do
      answer.set_best_answer
      answer2 = create(:answer, question: question)
      answer2.set_best_answer
      expect(answer.reload).to_not be_best
      expect(answer2.reload).to be_best
    end

    it 'check that question got only 1 best answer' do
      answer2 = create(:answer, question: question)
      answer3 = create(:answer, question: question)
      answer.set_best_answer
      answer2.set_best_answer
      answer3.set_best_answer
      expect(question.answers.where(best: true).count).to eq(1)
    end
  end

  describe 'concern' do
    it_behaves_like 'votable'
    it_behaves_like 'attachmentable'
    it_behaves_like 'commentable'
  end
end
