module Api
  module V1
    module Concerns
      module ErrorHandler
        extend ActiveSupport::Concern

        included do
          rescue_from ActiveRecord::RecordNotFound, with: :not_found
        end

        def render_error(message, status)
          status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          render json: { error: { status: status_code, message: message } },
                 status: status
        end

        def not_found
          render_error(I18n.t('errors.messages.not_found'), :not_found)
        end
      end
    end
  end
end
