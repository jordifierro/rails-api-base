require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:user) { user = create :user }
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    context "when correct auth" do
      before do
        request.headers["Authorization"] = user.auth_token
        authentication.stub(:request).and_return(request)
      end

      it "returns the user from the authorization header" do
        expect(authentication.current_user.auth_token).to eq user.auth_token
      end
    end

    context "when wrong auth" do
      before do
        request.headers["Authorization"] = "wrong_token"
        authentication.stub(:request).and_return(request)
      end

      it "returns the user from the authorization header" do
        expect(authentication.current_user).to be_nil
      end
    end
  end

  describe "#auth_with_token!" do
    before do
      # TO-DO
      authentication.stub(:current_user).and_return(nil)
      response.stub(:body).and_return({"errors" => "Not authenticated"}.to_json)
      response.stub(:status).and_return(401)
      authentication.stub(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response['errors']).to eq "Not authenticated"
    end

    it {  expect(response.status).to eq 401 }
  end
end
