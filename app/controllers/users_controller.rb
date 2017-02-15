class UsersController < ApplicationController
  before_action :set_user

  def finish_signup
    if request.patch? && params[:user]
      @user.send(:generate_confirmation_token)
      @user.update(user_params)
      Devise::Mailer.confirmation_instructions(@user, @user.confirmation_token).deliver_now
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
