class AnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      AnswerMailer.answer_published(user, answer.question, answer).deliver_later
    end
  end
end
