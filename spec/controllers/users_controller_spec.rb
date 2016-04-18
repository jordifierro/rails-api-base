require 'spec_helper'

RSpec.configure do |config|
  config.render_views = true
end

describe UsersController do
  let(:user) { create :user }
  let(:user_attr) { attributes_for :user }

  it 'routes correctly' do
    expect(get: '/users/confirm/3').to route_to('users#confirm', token: '3')
  end

  describe 'GET /users/confirm #confirm' do
    context 'when is confirmed successfully' do
      before(:each) do
        user.confirmation_sent_at = DateTime.current
        user.regenerate_confirmation_token
        user.save
        get :confirm, params: { token: user.confirmation_token }
      end

      it 'renders users/confirmed view' do
        expect(response.body).to render_template('users/confirmed')
      end

      it 'sets attribute values' do
        user.reload
        expect(user.confirmed_at).to_not be_nil
        expect(user.confirmation_token).to be_nil
      end
    end

    context 'when token is invalid' do
      before(:each) { get :confirm, params: { token: 'WRONG_TOKEN' } }

      it 'renders users/confirmed view' do
        expect(response.body).to render_template('users/invalid_confirmation')
      end

      it 'doesn\'t set conf_at attribute' do
        user.reload
        expect(user.confirmed_at).to be_nil
      end
    end
  end
end
