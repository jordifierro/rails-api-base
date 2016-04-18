class UsersController < ViewController
  def confirm
    user = User.find_by_confirmation_token(params[:token])
    if user
      user.confirmed_at = DateTime.current
      user.confirmation_token = nil
      user.save
      render '/users/confirmed'
    else
      render 'users/invalid_confirmation'
    end
  end
end
