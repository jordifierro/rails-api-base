require 'spec_helper'

module Api
  module V1
    describe Concerns::Authenticator, type: :controller do
      controller(ApiController) do
        def fake_current_user
          render json: current_user
        end
      end

      before do
        routes.draw do
          get 'fake_current_user' => 'api/v1/api#fake_current_user'
        end
      end

      context 'when correctly authenticated' do
        before { signed_get :fake_current_user, params: {} }

        it { expect(json_response['email']).to_not be_nil }
        it { expect(response.status).to eq 200 }
      end

      context 'when not authenticated' do
        before { get :fake_current_user, params: {} }

        it { expect(response.status).to eq 401 }
      end
    end
  end
end
