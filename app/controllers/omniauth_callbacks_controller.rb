class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback('facebook')
  end

  def twitter
    callback('twitter')
  end

  protected

  def callback(provider)
     @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.account_confirmed
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      render 'users/finish_signup'
    end
  end
end
