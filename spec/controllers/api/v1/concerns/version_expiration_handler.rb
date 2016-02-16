require 'spec_helper'
require 'date'

describe Api::V1::Concerns::VersionExpirationHandler, type: :controller do
  controller(Api::V1::ApiController) do
    def fake_method
      head :ok
    end
  end

  before { routes.draw { get 'fake_method' => 'anonymous#fake_method' } }

  context "when version is working" do
    before { signed_get :fake_method, nil }

    it { expect(response.status).to eq 200 }
  end

  context "when version has expired" do
    before do
      Date.stub(:today).and_return(2.months.from_now)
      signed_get :fake_method, nil
    end

    it "returns expired message" do
      expect(json_response['errors'][0]['message']).to eq I18n.t('version.expired')
    end

    it { expect(response.status).to eq 426 }
  end
end
