class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    obj = vote_params[:votable_type].constantize.find(vote_params[:votable_id])
    if !current_user.author_of?(obj)
      updated_rating = obj.rating + vote_params[:value].to_i
      ActiveRecord::Base.transaction do
        @vote = obj.votes.create!(vote_params.merge(users_id: current_user.id))
        obj.update!(rating: updated_rating)
      end
      respond_to do |format|
        format.json do
          if @vote.persisted?
            render json: { id: "#{obj.class.name.underscore}_#{obj.id}", rating: obj.rating, action: "vote" }
          else
            render json: obj.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    else
      respond_to do |format|
        format.json { render json: "U cant do it", status: :forbidden }
      end
    end
  end

  def destroy
    obj = vote_params[:votable_type].constantize.find(vote_params[:votable_id])
    vote = obj.votes.where(users_id: current_user.id).take
    if !current_user.author_of?(obj)
      updated_rating = obj.rating - vote.value.to_i
      ActiveRecord::Base.transaction do
        vote.destroy!
        obj.update!(rating: updated_rating)
      end
      respond_to do |format|
        format.json do
          if vote.persisted?
            render json: obj.errors.full_messages, status: :unprocessable_entity
          else
            render json: { id: "#{obj.class.name.underscore}_#{obj.id}", rating: obj.rating, action: "unvote" }
          end
        end
      end
    else
      respond_to do |format|
        format.json { render json: "U cant do it", status: :forbidden }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :value)
  end

end
