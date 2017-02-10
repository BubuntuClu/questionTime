class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, foreign_key: :users_id
  has_many :comments, foreign_key: :users_id
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(message)
    id == message.user_id
  end
end
