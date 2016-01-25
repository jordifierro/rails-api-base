module Api::V1
  class SessionsController < ApiController
    skip_before_action :auth_with_token!, only: [:create]

    def create
      user_email = params[:user][:email]
      user_password = params[:user][:password]
      user = user_email.present? && User.find_by(email: user_email)

      if user && user.valid_password?(user_password)
        sign_in(:user, [{store: false}, user])
        user.generate_auth_token!
        user.save
        render json: user, status: :ok
      else
        render json: { errors:
                        [ message: I18n.t('devise.failure.not_found_in_database',
                          { authentication_keys: 'email' })] }, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.generate_auth_token!
      current_user.save
      head :no_content
    end
  end
end
