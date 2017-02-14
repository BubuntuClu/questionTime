class UsersController < ApplicationController
  before_action :set_user

  def finish_signup
    
    if request.patch? && params[:user]
      binding.pry
      @user.send(:generate_confirmation_token)
      @user.update(user_params)
      # @user.save!
      # 
      # UserMailer.registration_confirmation(@user).deliver_now
      Devise::Mailer.confirmation_instructions(@user, @user.confirmation_token).deliver_now
      # binding.pry
    #   binding.pry
    #   if @user.update(user_params)
    #     sign_in(@user, bypass: true)
    #     redirect_to root_path, notice: 'Your email was confirmed.'
    #   else
    #     @show_errors = true
    #   end
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
