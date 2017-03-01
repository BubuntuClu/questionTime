class AnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |subscriber|
      AnswerMailer.answer_published(subscriber, answer.question, answer).deliver_later
    end
  end
end
