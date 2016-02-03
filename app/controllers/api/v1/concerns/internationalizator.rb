module Api::V1::Concerns
  module Internationalizator
    extend ActiveSupport::Concern

    included do
      before_action :set_locale
    end

    def set_locale
      I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
    end

    private

    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE']
        language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        if I18n.available_locales.include?(language.to_sym)
          language
        end
      end
    end
  end
end
