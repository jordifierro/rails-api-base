require 'spec_helper'
require 'date'

describe Api::V1::VersionsController, type: :controller do
  let(:user) { create :user }
  before(:each) do
    request.headers['Accept'] = 'application/vnd.railsapibase.v1'
    sign_in_user user
  end
  after(:each) do
    ENV['LAST_EXPIRED_VERSION'] = nil
    ENV['LAST_WARNED_VERSION'] = nil
  end

  it 'routes correctly' do
    expect(get: '/versions/state').to route_to(
      'api/v1/versions#state', format: :json)
  end

  describe 'GET /versions/state #state' do
    context 'when last expired and warned are less' do
      before(:each) do
        ENV['LAST_EXPIRED_VERSION'] = '0'
        ENV['LAST_WARNED_VERSION'] = '0'
        signed_get :state, nil
      end

      it 'returns expiration_date' do
        expect(json_response['state']).to eq 'OK'
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when last expired less but warned eq or greater' do
      before(:each) do
        ENV['LAST_EXPIRED_VERSION'] = '0'
        ENV['LAST_WARNED_VERSION'] = '1'
        signed_get :state, nil
      end

      it 'returns expiration_date' do
        expect(json_response['state']).to eq 'WARNED'
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when last expired eq or greater' do
      before(:each) do
        ENV['LAST_EXPIRED_VERSION'] = '2'
        ENV['LAST_WARNED_VERSION'] = '3'
        signed_get :state, nil
      end

      it 'returns expiration_date' do
        expect(json_response['state']).to eq 'EXPIRED'
      end

      it { expect(response.status).to eq 200 }
    end
  end
end
