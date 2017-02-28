class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :build_answer, only: :show
  after_action :publish_question, only: [:create]

  respond_to :html, :json, :js

  authorize_resource

  def index
    respond_with (@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with (@question = Question.new)
  end

  def edit
  end

  def create
    @question = Question.create(questions_params.merge(user_id: current_user.id))
    # @question.subscribe_user(current_user)
    respond_with @question
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with (@question.destroy) if current_user.author_of?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions', 
      question: @question,
      author: current_user.id,
      type: 'question'
    )
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes:[:file,  :id, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end
end
