class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments
end
