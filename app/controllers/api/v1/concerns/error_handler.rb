module Api::V1::Concerns
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, :with => :not_found
    end

    def render_errors(errors, status)
      render json: { errors: errors }, status: status
    end

    def not_found
      render_errors [{ message: I18n.t('errors.messages.not_found') }],
                                                                      :not_found
    end
  end
end
