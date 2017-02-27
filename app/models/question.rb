class Question < ApplicationRecord
  include Votable
  include Attachmentable
  include Commentable

  has_many :answers, dependent: :destroy
  
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }

  scope :created_today, ->{ where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  after_create -> { subscribe_user(self.user) }

  def subscribe_user(user)
    subscribers_will_change!
    update_attributes subscribers: subscribers.push(user.id)
  end

  def unsubscribe_user(user)
    subscribers_will_change!
    subscribers.delete(user.id)
    temp_array = subscribers
    temp_array ||= []
    update_attributes subscribers: temp_array
  end
end
