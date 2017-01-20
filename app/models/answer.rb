class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :ordered, -> { order("best DESC") }

  validates :body, presence: true, length: { minimum: 10 }


  def set_best_answer
    ActiveRecord::Base.transaction do
      old_best = self.question.answers.find_by(best: true)
      old_best.update!(best: false) unless old_best.blank?
      self.update!(best: true)
    end
  end
end
