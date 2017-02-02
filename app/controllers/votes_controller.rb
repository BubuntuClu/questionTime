class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    klass, id = request.path.split('/')[1,2]
    obj = klass.singularize.classify.constantize.find(id)
    if !current_user.author_of?(obj)
      vote = obj.send("vote_#{vote_params[:value]}", current_user, vote_params)
      if vote.persisted?
        render json: { id: "#{obj.class.name.underscore}_#{obj.id}", rating: obj.rating, action: "vote" }
      else
        render json: obj.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: "U cant do it", status: :forbidden 
    end
  end

  def destroy
    # klass, id = request.path.split('/')[1,2]
    # obj = klass.singularize.classify.constantize.find(id)
    obj = vote_params[:votable_type].constantize.find(vote_params[:votable_id])
    if !current_user.author_of?(obj) && obj.votes.where(users_id: current_user.id).take.users_id == current_user.id
      vote = obj.unvote(current_user)      
      if vote.persisted?
        render json: obj.errors.full_messages, status: :unprocessable_entity
      else
        render json: { id: "#{obj.class.name.underscore}_#{obj.id}", rating: obj.rating, action: "unvote" }
      end
    else
      render json: "U cant do it", status: :forbidden 
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :value)
  end

end
