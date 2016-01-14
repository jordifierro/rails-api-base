class Api::V1::SessionsController < ApplicationController
  def create
    user_email = params[:user][:email]
    user_password = params[:user][:password]
    user = user_email.present? && User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      sign_in(:user, [{store: false}, user])
      user.generate_auth_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end
end
=begin
  def create
    if @user = User.authenticate(params[:email], params[:password])
      self.current_user = @user
      token = @user.update_authentication_token
      render json: @user, authentication_token: token
    else
      render json: {message: I18n.t('sessions.wrong_password_combination')}, status: :unauthorized
    end
  end
=end
