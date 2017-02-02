module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(current_user, vote_params)
    updated_rating = self.rating + 1
    ActiveRecord::Base.transaction do
      @vote = self.votes.create!(vote_params.merge(users_id: current_user.id, value: 1))
      self.update!(rating: updated_rating)
    end
    @vote
  end

  def vote_down(current_user, vote_params)
    updated_rating = self.rating - 1
    ActiveRecord::Base.transaction do
      @vote = self.votes.create!(vote_params.merge(users_id: current_user.id, value: -1))
      self.update!(rating: updated_rating)
    end
    @vote
  end

  def unvote(current_user)
    vote = self.votes.where(users_id: current_user.id).take
    updated_rating = self.rating - vote.value.to_i
    ActiveRecord::Base.transaction do
      vote.destroy!
      self.update!(rating: updated_rating)
    end
    vote
  end
end
