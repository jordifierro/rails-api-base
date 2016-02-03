require 'date'

module Api::V1::Concerns
  module VersionExpirationHandler
    extend ActiveSupport::Concern

    included do
      before_action :check_expiration!
    end

    def expiration_date
      @expiration_date ||= 1.month.from_now
    end

    def check_expiration!
      render json: { errors: [ message: I18n.t('version.expired') ] },
                        status: :upgrade_required unless supported_version?
    end

    def supported_version?
      expiration_date && Date.today < expiration_date
    end
  end
end
