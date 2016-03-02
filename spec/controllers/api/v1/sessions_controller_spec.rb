require 'spec_helper'

describe Api::V1::SessionsController do
  let(:user) { create :user }

  it 'routes correctly' do
    expect(post: '/users/login').to route_to(
      'api/v1/sessions#create', format: :json)
    expect(delete: '/users/logout').to route_to(
      'api/v1/sessions#destroy', format: :json)
  end

  describe 'POST /users/login #create' do
    context 'when credentials are correct' do
      before(:each) do
        user_attr = attributes_for :user
        user_attr[:email] = user.email
        post :create, params: { user: user_attr }
      end

      it 'renders user' do
        expect(json_response['id']).to_not be_nil
        expect(json_response['email']).to eq user.email
        expect(json_response['password']).to be_nil
        expect(json_response['auth_token']).to_not be_nil
      end

      it 'returns new user token' do
        user.reload
        expect(json_response['auth_token']).to eql user.auth_token
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when credentials are wrong' do
      it 'because of email' do
        user.email = 'wrong@email.com'
        post :create, params: { user: user.attributes }
        expect(json_response['error']).to_not be_nil
      end

      it 'because of password' do
        user.password = 'invalid_password'
        process :create, method: :post, params: { user: user.attributes }
        expect(json_response['error']['message']).to eq 'Invalid email or '\
                                                                'password.'
      end

      it 'and returns 422' do
        user.email = 'wrong@email.com'
        process :create, method: :post, params: { user: user.attributes }
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE /users/logout #destroy' do
    context 'when logout correctly' do
      before(:each) { signed_delete :destroy, nil }

      it 'cannot be found anymore' do
        expect do
          User.find_by!(auth_token: user.auth_token)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { expect(response.status).to eq 204 }
    end

    context 'when doesn\'t exists' do
      before(:each) { delete :destroy, params: { id: 'unused_token' } }

      it { expect(response.status).to eq 401 }
    end
  end
end
