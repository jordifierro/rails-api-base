class UsersController < ActionController::Base
  def confirm
    user = User.find_by_confirmation_token(params[:token])
    if user
      user.conf_at = DateTime.current
      user.conf_token = nil
      user.save
      render 'users/confirmed'
    else
      render 'users/invalid_confirmation'
    end
  end
end
