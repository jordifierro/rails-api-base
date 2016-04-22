module Api
  module V1
    class VersionsController < ApiController
      def expiration
        if expiration_date
          render json: { expiration_date:
            Date.parse(expiration_date).strftime('%x') }
        else
          render json: { expiration_date: '' }
        end
      end
    end
  end
end
