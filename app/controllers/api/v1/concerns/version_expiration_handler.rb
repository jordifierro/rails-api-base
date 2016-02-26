require 'date'

module Api
  module V1
    module Concerns
      module VersionExpirationHandler
        extend ActiveSupport::Concern

        included do
          before_action :check_expiration!
        end

        def api_version
          self.class.superclass.name.to_s.split('::').second
        end

        def expiration_date
          @expiration_date ||= ENV[api_version + '_EXPIRATION_DATE']
        end

        def check_expiration!
          render_errors(
            [{ message: I18n.t('version.expired') }],
            :upgrade_required) unless supported_version?
        end

        def supported_version?
          !expiration_date || Time.zone.today < Date.parse(expiration_date)
        end
      end
    end
  end
end
