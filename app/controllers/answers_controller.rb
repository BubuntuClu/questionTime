class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
  end

  def mark_best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.set_best_answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

end
