module Api::V1
  class UsersController < ApiController

    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: 201
      else
        render json: { errors: user.errors }, status: 422
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      head 204
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
