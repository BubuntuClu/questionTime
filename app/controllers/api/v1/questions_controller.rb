class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions , each_serializer: QuestionListSerializer
  end

  def show
    respond_with(@question = Question.find(params[:id]))
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_resource_owner.id)) )
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
