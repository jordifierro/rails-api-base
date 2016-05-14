module Api
  module V1
    class VersionsController < ApiController
      skip_before_action :check_expiration!

      def state
        render json: { state: expiration_state }
      end
    end
  end
end
