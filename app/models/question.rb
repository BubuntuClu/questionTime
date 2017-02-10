class Question < ApplicationRecord
  include Votable
  include Attachmentable
  include Commentable

  has_many :answers, dependent: :destroy
  
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }

  
end
