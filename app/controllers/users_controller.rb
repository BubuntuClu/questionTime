class UsersController < ApplicationController
  before_action :set_user

  def finish_signup
    @user.send_email(user_params)      
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
