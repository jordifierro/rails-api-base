require 'spec_helper'

describe Api::V1::SessionsController do
  it "routes correctly" do
    expect(post: "/users/login").to route_to("api/v1/sessions#create", format: :json)
    expect(delete: "/users/logout").to route_to("api/v1/sessions#destroy", format: :json)
  end
end
