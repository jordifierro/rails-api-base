module Requests
  module JsonHelpers
    def json_response
      JSON.parse(response.body)
    end
  end

  module SignedRequestHelpers
    def set_auth_header(token)
      request.headers["Authorization"] = token
    end
  end
end
