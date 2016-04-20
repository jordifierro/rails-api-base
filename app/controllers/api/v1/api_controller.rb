module Api
  module V1
    class ApiController < ApplicationController
      include ::ActionController::Serialization

      include Concerns::Authenticator
      include Concerns::ErrorHandler
      include Concerns::VersionExpirationHandler
      include Concerns::Internationalizator
    end
  end
end
