class UsersController < ViewController
  def confirm
    user = User.find_by_confirmation_token(params[:token])
    if user
      user.confirmed_at = DateTime.current
      user.confirmation_token = nil
      user.confirmation_token = nil
      user.confirmation_token = nil
      user.save
      render '/users/confirmed'
    else
      render 'users/invalid_confirmation'
    end
  end

  def confirm_reset
    user = User.find_by_reset_password_token(params[:token])
    if user && user.reset_password_digest
      user.password_digest = user.reset_password_digest
      user.reset_password_token = nil
      user.reset_password_digest = nil
      user.save
      render '/users/reset_confirmed'
    else
      render 'users/invalid_reset_confirmation'
    end
  end
end
