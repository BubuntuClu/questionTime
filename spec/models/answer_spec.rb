require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'best answer' do
    before { @user = create(:user) }
    let!(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, question: question, user: @user) }

    it 'set asnwer as a best' do
      Answer.set_best_answer(question, answer)
      expect(answer.reload.best).to eq(true)
    end

    it 'set another asnwer as a best' do
      Answer.set_best_answer(question, answer)
      answer2 = create(:answer, question: question, user: @user)
      Answer.set_best_answer(question, answer2)
      expect(answer.reload.best).to eq(false)
      expect(answer2.reload.best).to eq(true)
    end

    it 'check that question got only 1 best answer' do
      answer2 = create(:answer, question: question, user: @user)
      answer3 = create(:answer, question: question, user: @user)
      Answer.set_best_answer(question, answer)
      Answer.set_best_answer(question, answer2)
      Answer.set_best_answer(question, answer3)
      expect(question.answers.where(best: true).count).to eq(1)
    end

  end
end
