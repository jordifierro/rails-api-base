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

      after(:each) { ENV['LAST_EXPIRED_VERSION'] = nil }

      context 'when no expiration date' do
        before { signed_get :fake_method, params: {} }

        it { expect(response.status).to eq 200 }
      end

      context 'when expired is less' do
        before do
          ENV['LAST_EXPIRED_VERSION'] = '0'
          signed_get :fake_method, params: {}
        end

        it { expect(response.status).to eq 200 }
      end

      context 'when version is equal or greater' do
        before do
          ENV['LAST_EXPIRED_VERSION'] = '1'
          signed_get :fake_method, params: {}
        end

        it 'returns expired message' do
          expect(json_response['error']['message']).to eq I18n.t(
            'version.expired')
          expect(json_response['error']['status']).to eq 426
          expect(response.status).to eq 426
        end
      end
    end
  end
end
