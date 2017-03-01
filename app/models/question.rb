class Question < ApplicationRecord
  include Votable
  include Attachmentable
  include Commentable

  has_many :answers, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }

  scope :created_today, ->{ where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  after_create :subscribe_user

  def subscribe_user
    self.subscriptions.create(user_id: self.user.id)
  end
end
