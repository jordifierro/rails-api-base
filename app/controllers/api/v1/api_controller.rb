module Api::V1
  class ApiController < ApplicationController
    include Concerns::Authenticable
    include Concerns::ErrorHandler
  end
end
