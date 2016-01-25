module Api::V1::Concerns
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, :with => :not_found
    end

    def not_found
      render json: { errors: { not_found: I18n.t('error.messages.not_found') } },
                      status: :not_found
    end
  end
end
