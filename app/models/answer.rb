class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :ordered, -> { order("best DESC") }

  validates :body, presence: true, length: { minimum: 10 }


  def self.set_best_answer(question, answer)
    ActiveRecord::Base.transaction do
      old_best = question.answers.find_by(best: true)
      old_best.update_attribute(:best, false) unless old_best.blank?
      answer.update_attribute(:best, true)
    end
  end
end
