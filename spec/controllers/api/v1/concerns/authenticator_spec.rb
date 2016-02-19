require 'spec_helper'

describe Api::V1::Concerns::Authenticator, type: :controller do
  controller(Api::V1::ApiController) do
    def fake_current_user
      render json: current_user
    end
  end

  before do
    routes.draw { get 'fake_current_user' => 'anonymous#fake_current_user' }
  end

  context "when correctly authenticated" do
    before { signed_get :fake_current_user, nil }

    it { expect(json_response['email']).to_not be_nil }
    it { expect(response.status).to eq 200 }
  end

  context "when not authenticated" do
    before { get :fake_current_user, nil }

    it { expect(response.status).to eq 401 }
  end
end
