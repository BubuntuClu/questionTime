require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for simple user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:comment) { create(:comment, users_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:question_attachment) { create(:question_attachment, attachmentable: question) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question}
    it { should be_able_to :create, Answer}
    it { should be_able_to :create, Comment}
    it { should be_able_to :create, Vote}

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, comment, users_id: user.id }
    it { should_not be_able_to :destroy, create(:comment, users_id: other_user.id), users_id: user.id }

    it { should be_able_to :manage, question_attachment, user: question_attachment.attachmentable.user }

    it { should be_able_to :mark_best, answer.question, user: answer.question.user }

  end

  
end
