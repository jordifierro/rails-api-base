require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:user) { user = create :user }
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      request.headers["Authorization"] = user.auth_token
      authentication.stub(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eq user.auth_token
    end
  end
end
