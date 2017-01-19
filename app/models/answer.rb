class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :ordered, -> { order("best DESC") }

  validates :body, presence: true, length: { minimum: 10 }
end
