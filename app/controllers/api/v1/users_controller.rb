module Api
  module V1
    class UsersController < ApiController
      skip_before_action :auth_with_token!, only: [:create]

      def create
        if request.headers['Authorization'] == ENV['SECRET_API_KEY']
          user = User.new(user_params)
          if user.save
            render json: user, status: :created
          else
            render_error(user.errors.full_messages[0], :unprocessable_entity)
          end
        else
          head :unauthorized
        end
      end

      def destroy
        current_user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
