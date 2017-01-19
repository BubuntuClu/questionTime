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
    @question = Question.find(params[:q_id])
    old_best = @question.answers.find_by(best: true)
    unless old_best.blank?
      old_best.best = false
      old_best.save
    end
    @answer = Answer.find(params[:a_id])
    @answer.best = true
    @answer.save
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

end
