module Requests
  module JsonHelpers
    def json_response
      JSON.parse(response.body)
    end
  end
end
