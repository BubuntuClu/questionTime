module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(current_user, vote_params)
    ActiveRecord::Base.transaction do
      @vote = self.votes.create!(vote_params.merge(users_id: current_user.id, value: 1))
      self.update!(rating: sum )
    end
    @vote
  end

  def vote_down(current_user, vote_params)
    ActiveRecord::Base.transaction do
      @vote = self.votes.create!(vote_params.merge(users_id: current_user.id, value: -1))
      self.update!(rating: sum )
    end
    @vote
  end

  def unvote(current_user)
    vote = self.votes.where(users_id: current_user.id).take    
    ActiveRecord::Base.transaction do
      vote.destroy!
      self.update!(rating: sum)
    end
    vote
  end

  def sum
    self.votes.sum(:value)
  end
end
