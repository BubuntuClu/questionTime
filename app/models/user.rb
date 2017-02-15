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

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def author_of?(message)
    id == message.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first #.find_for_oauth(auth)
    return authorization.user if authorization

    email = begin
              auth.info[:email] 
            rescue 
              nil
            end
    email = "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" unless email
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

  def create_authorization(auth) 
    authorizations.create(provider: auth.provider, uid: auth.uid) 
  end
end
