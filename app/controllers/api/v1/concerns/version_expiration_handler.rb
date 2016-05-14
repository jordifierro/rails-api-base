require 'date'

module Api
  module V1
    module Concerns
      module VersionExpirationHandler
        extend ActiveSupport::Concern
        OK = 'OK'.freeze
        WARNED = 'WARNED'.freeze
        EXPIRED = 'EXPIRED'.freeze

        included do
          before_action :check_expiration!
        end

        def api_version
          self.class.superclass.name.to_s.split('::').second.sub('V', '').to_i
        end

        def expiration_state
          @expired ||= ENV['LAST_EXPIRED_VERSION']
          return EXPIRED if @expired && api_version <= @expired.to_i
          @warned ||= ENV['LAST_WARNED_VERSION']
          return WARNED if @warned && api_version <= @warned.to_i
          OK
        end

        def check_expiration!
          render_error(I18n.t('version.expired'),
                       :upgrade_required) unless supported_version?
        end

        def supported_version?
          expiration_state && expiration_state != EXPIRED
        end
      end
    end
  end
end
