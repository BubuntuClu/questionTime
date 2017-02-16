class UsersController < ApplicationController
  before_action :set_user

  def finish_signup
    if !User.find_by(email: user_params[:email])
      @user.send_confirmation(user_params)
    else
      @user.errors.add(:email, 'Такой email уже есть в системе. Пожалуйста введите другой')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [:email]
    accessible << [ :password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
