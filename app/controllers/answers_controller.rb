class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :load_answer, except: [:new, :create]

  after_action :publish_answer, only: [:create]

  authorize_resource

  respond_to :json, :js

  def create
    @answer = @question.answers.new(answer_params)
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
    respond_with (@question) 
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def mark_best
    @question = @answer.question
    @answer.set_best_answer
    respond_with @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?
    attachments = []
    @answer.attachments.each { |a| attachments << { id: a.id, identifier: a.file.identifier, url: a.file.url } }
    ActionCable.server.broadcast(
      "question_#{@question.id}_answers", 
      answer: @answer,
      attachments: attachments,
      author: current_user.id,
      type: 'answer'
    )
  end

end
