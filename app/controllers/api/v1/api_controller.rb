class Api::V1::ApiController < ApplicationController
  before_action :auth_with_token!

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def not_found
    render json: { errors: { not_found: "Resource not found" } }, status: :not_found
  end
end
