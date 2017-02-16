class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_obj
  after_action :publish_comment, only: [:create]
  authorize_resource
  respond_to :json
  
  def create
    @comment = @obj.comments.create(comment_params.merge(users_id: current_user.id))
    if @comment.persisted?
      render json: @comment 
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
    # Если этот метод написать вместо кода выше, то он пытается отрендерить CommentsController#show вместо просто отправки json
    # respond_with(@comment = @obj.comments.create(comment_params.merge(users_id: current_user.id)))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_obj_by_url(request)
    klass, id = request.path.split('/')[1,2]
    klass.singularize.classify.constantize.find(id)
  end

  def get_obj
    @obj = get_obj_by_url(request)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "question_#{@obj.id}_comments", 
      comment: @comment,
      author: current_user.id
    )
  end

end
