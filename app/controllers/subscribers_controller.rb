class SubscribersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :js
  
  def create
    @question = Question.find(params[:question_id])
    respond_with(@subscriber = @question.subscribers.create(user: current_user))
  end

  def destroy
    @subscriber = Subscriber.find(params[:id])
    @question = @subscriber.question
    @subscriber.destroy
    respond_with(@subscriber)
  end

end
