require 'spec_helper'

RSpec.configure do |config|
  config.render_views = true
end

describe UsersController do
  let(:user) { create :user }
  let(:user_attr) { attributes_for :user }

  it 'routes correctly' do
    expect(get: '/users/confirm/3').to route_to('users#confirm', token: '3')
    expect(get: '/users/confirm_reset/4').to route_to('users#confirm_reset',
                                                      token: '4')
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

      it 'renders users/invalid_confirmation view' do
        expect(response.body).to render_template('users/invalid_confirmation')
      end

      it 'doesn\'t set conf_at attribute' do
        user.reload
        expect(user.confirmed_at).to be_nil
      end
    end
  end

  describe 'GET /users/confirm_reset #confirm_reset' do
    context 'when reset is confirmed successfully' do
      before(:each) do
        user.ask_reset_password('87654321', '87654321')
        get :confirm_reset, params: { token: user.reset_password_token }
      end

      it 'renders users/reset_confirmed view' do
        expect(response.body).to render_template('users/reset_confirmed')
      end

      it 'sets attribute values' do
        old_pass_digest = user.password_digest
        new_pass_digest = user.reset_password

        user.reload

        expect(user.password_digest).to_not eq old_pass_digest
        expect(user.password_digest).to eq new_pass_digest
        expect(user.reset_password_token).to be_nil
        expect(user.reset_password).to be_nil
      end
    end

    context 'when token is invalid' do
      before(:each) { get :confirm_reset, params: { token: 'WRONG_TOKEN' } }

      it 'renders users/invalid_reset_confirmation view' do
        expect(response.body).to render_template(
          'users/invalid_reset_confirmation')
      end

      it 'doesn\'t set attributes' do
        old_pass_digest = user.password_digest
        new_pass_digest = user.reset_password

        user.reload

        expect(user.password_digest).to eq old_pass_digest
        expect(user.password_digest).to_not eq new_pass_digest
        expect(user.reset_password_token).to_not be_nil
        expect(user.reset_password).to eq new_pass_digest
      end
    end
  end
end
