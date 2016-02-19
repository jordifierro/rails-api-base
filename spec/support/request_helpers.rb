module Requests
  module JsonHelpers
    def json_response
      JSON.parse(response.body)
    end
  end

  module SignedRequestHelpers
    def current_user
      @user ||= try(:user) || create(:user)
    end

    def signed_get(action, params = {})
      sign_request
      get(action, params)
    end

    def signed_post(action, params = {})
      sign_request
      post(action, params)
    end

    def signed_put(action, params = {})
      sign_request
      put(action, params)
    end

    def signed_delete(action, params = {})
      sign_request
      delete(action, params)
    end

    def sign_in_user(user)
      set_auth_header(user)
    end

    private

    def sign_request
      return unless @request.headers["Authorization"].blank?
      set_auth_header(current_user)
    end

    def set_auth_header(current_user)
      request.headers["Authorization"] = current_user.auth_token
    end
  end
end
