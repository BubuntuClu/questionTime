require 'rails_helper'

RSpec.describe AnswerJob, type: :job do
  let!(:subscribers) { create_list(:user, 2) }
  let!(:question) { create(:question, user: subscribers[0]) }
  let!(:not_subscribers) { create_list(:user, 2) }

  it 'sends notifications to all subscribers users when answer created' do
    question.subscriptions.create(user_id: subscribers[1].id)
    answer = create(:answer, question: question)
    subscribers.each do |subscriber|
      expect(AnswerMailer).to receive(:answer_published).with(subscriber, question, answer).and_call_original
    end
    AnswerJob.perform_now(answer)
  end

  it 'does not send notifications to notsubscribers users when answer created' do
    answer = create(:answer, question: question)
    not_subscribers.each do |not_subscriber|
      expect(AnswerMailer).to_not receive(:answer_published).with(not_subscriber, question, answer).and_call_original
    end
    AnswerJob.perform_now(answer)
  end
end
