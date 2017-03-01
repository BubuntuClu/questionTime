class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'temp@temp'
  TEMP_EMAIL_REGEX = /\Atemp@temp/

  before_create :confirmation_token
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, foreign_key: :users_id
  has_many :comments, foreign_key: :users_id
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  scope :other_users, -> (my_id) { where.not(id: my_id).order(:id) }

  def author_of?(message)
    id == message.user_id
  end

  def subscribed?(question)
    question.subscribers.find_by(id: id).present?
  end

  def send_confirmation(params)
    self.generate_confirmation_token!
    self.update(params)
    Devise::Mailer.confirmation_instructions(self, self.confirmation_token).deliver_now
  end

  def create_authorization(auth) 
    authorizations.create(provider: auth.provider, uid: auth.uid) 
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] if auth.info && auth.info[:email] 
    email ||= "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"

    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[1, 20]
      user = User.new(email: email , password: password, password_confirmation: password, account_confirmed: (email != "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com") ? true : false)
      user.skip_confirmation!
      user.save!
      user.create_authorization(auth)
    end
    
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

end
