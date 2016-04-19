module Api
  module V1
    class UsersController < ApiController
      skip_before_action :auth_with_token!, only: [:create, :reset_password]

      def create
        if correct_secret_api_key?
          user = User.new(user_params)
          if user.save
            render json: user, status: :created
          else
            render_error(user.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def destroy
        current_user.notes.destroy_all
        current_user.destroy
        head :no_content
      end

      def reset_password
        user = User.find_by_email(user_params[:email])
        if user
          user.ask_reset_password(user_params[:new_password],
                                  user_params[:new_password_confirmation])
        else
          user = User.new(user_params)
          user.password = '12345678'
        end
        reset_password_output(user)
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :new_password, :new_password_confirmation)
      end

      def correct_secret_api_key?
        if request.headers['Authorization'] == ENV['SECRET_API_KEY']
          true
        else
          head :unauthorized
          false
        end
      end

      def reset_password_output(user)
        if user.valid?
          render json: { message: I18n.t('reset_password.sent') },
                 status: :accepted
        else
          render_error(user.errors.full_messages[0], :unprocessable_entity)
        end
      end
    end
  end
end
