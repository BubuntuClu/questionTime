class Api::V1::AnswersController < Api::V1::BaseController
  before_action :get_question, only: [:index, :create]
  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerListSerializer
  end

  def show
    respond_with(@answer = Answer.find(params[:id]))
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  private
  
  def answer_params
    params.require(:answer).permit(:body)
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

end
