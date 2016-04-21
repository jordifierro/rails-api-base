module Concerns
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      has_secure_password
      has_secure_token :auth_token

      validates :email, uniqueness: true, format: /@/
      validates :password, length: { minimum: 8 }, on: :create
    end
  end
end
