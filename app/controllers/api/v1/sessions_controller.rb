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
      render json: { errors:
                      [ message: I18n.t('devise.failure.not_found_in_database',
                        { authentication_keys: 'email' })] }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if user
      user.generate_auth_token!
      user.save
      head 204
    else
      head 401
    end
  end
end
