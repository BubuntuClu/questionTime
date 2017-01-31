class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :votes, as: :votable

  scope :ordered, -> { order("best DESC") }

  validates :body, presence: true, length: { minimum: 10 }
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_best_answer
    ActiveRecord::Base.transaction do
      old_best = self.question.answers.find_by(best: true)
      old_best.update!(best: false) if old_best
      self.update!(best: true)
    end
  end
end
