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
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def author_of?(message)
    id == message.user_id
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    authorization = Authorization.find_for_oauth(auth) # where(provider: auth.provider, uid: auth.uid.to_s).first
    # return authorization.user if authorization

    # email = auth.info[:email]
    # user = User.where(email: email).first
    # if user
    #   user.create_authorization(auth)
    # else
    #   password = Devise.friendly_token[1, 20]
    #   user = User.create!(email: email, password: password, password_confirmation: password)
    #   user.create_authorization(auth)
    # end
    # user

    user = signed_in_resource ? signed_in_resource : authorization.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      if user.nil?
        password = Devise.friendly_token[1, 20]
        user = User.new(email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com", password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save!
      end
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end
    user
  end

  def create_authorization(auth) 
    authorizations.create(provider: auth.provider, uid: auth.uid) 
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end


end
