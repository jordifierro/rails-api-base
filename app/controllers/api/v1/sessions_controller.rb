module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :auth_with_token!, only: [:create]

      def create
        user = check_user
        if user
          login_user(user)
          render json: user, status: :ok
        else
          render_error(I18n.t('devise.failure.not_found_in_database',
                              authentication_keys: 'email'),
                       :unprocessable_entity)
        end
      end

      def destroy
        current_user.regenerate_auth_token
        head :no_content
      end

      private

      def check_user
        user_email = params[:user][:email]
        user = user_email.present? && User.find_by(email: user_email)
        user if user && user.valid_password?(params[:user][:password])
      end

      def login_user(user)
        sign_in(:user, [{ store: false }, user])
        user.regenerate_auth_token
      end
    end
  end
end
