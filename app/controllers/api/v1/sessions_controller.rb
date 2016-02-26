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
          render_errors([message: I18n.t(
            'devise.failure.not_found_in_database',
            authentication_keys: 'email')], :unprocessable_entity)
        end
      end

      def destroy
        current_user.generate_auth_token!
        current_user.save
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
        user.generate_auth_token!
        user.save
      end
    end
  end
end
