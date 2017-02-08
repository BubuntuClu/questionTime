class AnswersChannel < ApplicationCable::Channel
  def follow_question_answers(data)
    stream_from "question_#{data['question_id']}_answers"
  end
end
