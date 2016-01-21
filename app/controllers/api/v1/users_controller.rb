module Api::V1
  class UsersController < ApiController
    before_action :auth_with_token!, except: [:create]

    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
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
