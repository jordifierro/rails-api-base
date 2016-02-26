module Api
  module V1
    module Concerns
      module Internationalizator
        extend ActiveSupport::Concern

        included do
          before_action :set_locale
        end

        def set_locale
          I18n.locale = extract_locale_from_accept_language_header ||
                        I18n.default_locale
        end

        private

        def extract_locale_from_accept_language_header
          req_lang = request.env['HTTP_ACCEPT_LANGUAGE']
          if req_lang
            language = req_lang.scan(/^[a-z]{2}/).first
            language if I18n.available_locales.include?(language.to_sym)
          end
        end
      end
    end
  end
end
