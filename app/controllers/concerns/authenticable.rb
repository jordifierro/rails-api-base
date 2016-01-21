module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def auth_with_token!
    head :unauthorized unless current_user.present?
  end
end
