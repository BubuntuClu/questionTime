class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]
  def create
    @obj = get_obj_by_url(request)
    @comment = @obj.comments.create(comment_params.merge(users_id: current_user.id))
    if @comment.persisted?
      render json: @comment 
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_obj_by_url(request)
    klass, id = request.path.split('/')[1,2]
    klass.singularize.classify.constantize.find(id)
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
