require 'spec_helper'
require 'date'

describe Api::V1::VersionsController, type: :controller do
  let(:user) { create :user }
  before(:each) do
    request.headers['Accept'] = 'application/vnd.railsapibase.v1'
    sign_in_user user
  end
  after(:each) { ENV['V1_EXPIRATION_DATE'] = nil }

  it 'routes correctly' do
    expect(get: '/versions/expiration').to route_to(
      'api/v1/versions#expiration', format: :json)
  end

  describe 'GET /versions/:id #show' do
    context 'when expiration date exists' do
      before(:each) do
        ENV['V1_EXPIRATION_DATE'] = 1.month.from_now.to_s
        signed_get :expiration, nil
      end

      it 'returns expiration_date' do
        exp_date = json_response['expiration_date']
        expect(exp_date).to eq 1.month.from_now.strftime('%x')
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when expiration date doesn\'t exists' do
      before(:each) do
        ENV['V1_EXPIRATION_DATE'] = nil
        signed_get :expiration, nil
      end

      it 'returns void expiration_date' do
        expect(json_response['expiration_date']).to eq ''
      end

      it { expect(response.status).to eq 200 }
    end
  end
end
