require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes) }

  context "votes" do
    let(:user) { create(:user) }
    let(:obj) { create(described_class) }

    it "vote up" do
      obj.vote_up(user, { votable_id: obj.id, votable_type: "obj", value: "up" })
      expect(obj.rating).to eq(1)
    end

    it "vote down" do
      obj.vote_down(user, { votable_id: obj.id, votable_type: "obj", value: "down" })
      expect(obj.rating).to eq(-1)
    end

    it "unvote" do
      obj.vote_down(user, { votable_id: obj.id, votable_type: "obj", value: "down" })
      obj.unvote(user)
      expect(obj.rating).to eq(0)
    end

    it "voted_for" do
      val = obj.voted_for(user)
      expect(val).to eq(0)
      obj.vote_down(user, { votable_id: obj.id, votable_type: "obj", value: "down" })
      val = obj.voted_for(user)
      expect(obj.rating).to eq(-1)
    end

    it "author of vote?" do
      obj.vote_down(user, { votable_id: obj.id, votable_type: "obj", value: "down" })
      expect(obj.author_of_vote?(user)).to be true
    end
  end
end
