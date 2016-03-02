require 'spec_helper'
require 'date'

module Api
  module V1
    describe Concerns::VersionExpirationHandler, type: :controller do
      controller(ApiController) do
        def fake_method
          head :ok
        end
      end

      before { routes.draw { get 'fake_method' => 'api/v1/api#fake_method' } }

      after(:each) { ENV['V1_EXPIRATION_DATE'] = nil }

      context 'when no expiration date' do
        before { signed_get :fake_method, nil }

        it { expect(response.status).to eq 200 }
      end

      context 'when expiration is later' do
        before do
          ENV['V1_EXPIRATION_DATE'] = 1.month.from_now.to_s
          signed_get :fake_method, nil
        end

        it { expect(response.status).to eq 200 }
      end

      context 'when version has expired' do
        before do
          ENV['V1_EXPIRATION_DATE'] = 1.month.ago.to_s
          signed_get :fake_method, nil
        end

        it 'returns expired message' do
          expect(json_response['error']['message']).to eq I18n.t(
            'version.expired')
        end

        it { expect(response.status).to eq 426 }
      end
    end
  end
end
