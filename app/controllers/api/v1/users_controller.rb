module Api::V1
  class UsersController < ApiController
    before_action :auth_with_token!, except: [:create]

    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: 201
      else
        render json: { errors: user.errors }, status: 422
      end
    end

    def destroy
      current_user.destroy
      head 204
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
