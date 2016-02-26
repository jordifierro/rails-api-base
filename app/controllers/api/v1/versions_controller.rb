module Api
  module V1
    class VersionsController < ApiController
      def expiration
        if expiration_date
          render json: { message: I18n.t(
            'version.expiration',
            expiration_date: Date.parse(expiration_date).strftime('%x')) }
        else
          head :no_content
        end
      end
    end
  end
end
