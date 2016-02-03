module Api::V1
  class VersionsController < ApiController
    def expiration
      if expiration_date
        render json: { errors: [ message: I18n.t('version.expiration',
                                          { expiration_date: expiration_date.strftime('%x') })] }
      else
        render :no_content
      end
    end
  end
end
