class Api::V1::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def not_found
    render json: { errors: { not_found: "Resource not found" } }, status: 404
  end
end
