class Answer < ApplicationRecord
  include Votable
  include Attachmentable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user

  scope :ordered, -> { order("best DESC") }

  validates :body, presence: true, length: { minimum: 10 }
  
  after_create :send_notification

  def set_best_answer
    ActiveRecord::Base.transaction do
      old_best = self.question.answers.find_by(best: true)
      old_best.update!(best: false) if old_best
      self.update!(best: true)
    end
  end

  def send_notification
    AnswerJob.perform_later(self)
  end
end
