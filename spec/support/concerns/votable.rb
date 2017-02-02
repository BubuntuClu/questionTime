require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes) }

  context "votes" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it "vote up" do
      question.vote_up(user, { votable_id: question.id, votable_type: "Question", value: "up" })
      expect(question.rating).to eq(1)
    end

    it "vote down" do
      question.vote_down(user, { votable_id: question.id, votable_type: "Question", value: "down" })
      expect(question.rating).to eq(-1)
    end

    it "unvote" do
      question.vote_down(user, { votable_id: question.id, votable_type: "Question", value: "down" })
      question.unvote(user)
      expect(question.rating).to eq(0)
    end

  end
end
