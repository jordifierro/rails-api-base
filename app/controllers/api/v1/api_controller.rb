module Api::V1
  class ApiController < ApplicationController
    include Concerns::Authenticator
    include Concerns::ErrorHandler
    include Concerns::VersionExpirationHandler
    include Concerns::Internationalizator
  end
end
