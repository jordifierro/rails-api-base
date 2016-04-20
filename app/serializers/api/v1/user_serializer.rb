module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :email, :auth_token
    end
  end
end
