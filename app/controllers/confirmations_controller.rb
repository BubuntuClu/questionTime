class ConfirmationsController < Devise::ConfirmationsController

  def show
    user = User.find_by(confirmation_token: params[:confirmation_token])
    if user
      user.update!(account_confirmed: true) 
      redirect_to root_path, notice: 'Your email was confirmed. Now u can sign in.'
    else
      redirect_to root_path, notice: 'OOups.Smthng went wrong!'
    end
  end
end
