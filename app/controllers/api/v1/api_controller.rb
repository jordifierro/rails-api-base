module Api::V1
  class ApiController < ApplicationController
    include Concerns::Authenticable
    include Concerns::ErrorHandler
    include Concerns::VersionExpirationHandler
  end
end
