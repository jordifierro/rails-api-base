require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { create :user }
  let(:user_attr) { attributes_for :user }
  before(:each) do
    ENV['SECRET_API_KEY'] = nil
    request.headers['Accept'] = 'application/vnd.railsapibase.v1'
  end

  it 'routes correctly' do
    expect(post: '/users').to route_to('api/v1/users#create', format: :json)
    expect(delete: '/users/1').to route_to(
      'api/v1/users#destroy', id: '1', format: :json)
    expect(post: '/users/reset_password').to route_to(
      'api/v1/users#reset_password', format: :json)
  end

  describe 'POST /users #create' do
    context 'when is created successfully' do
      before(:each) do
        post :create, params: { user: user_attr }
      end

      it 'renders resource created' do
        expect(json_response['id']).to_not be_nil
        expect(json_response['email']).to eq user_attr[:email]
        expect(json_response['password']).to be_nil
        expect(json_response['password_confirmation']).to be_nil
        expect(json_response['password_digest']).to be_nil
        expect(json_response['auth_token']).to_not be_nil
        expect(json_response['confirmation_token']).to_not be_nil
        expect(json_response['confirmation_sent_at']).to_not be_nil
        expect(json_response['confirmation_at']).to be_nil
      end

      it { expect(User.find(json_response['id'])).to_not be_nil }
      it { expect(response.status).to eq 201 }
    end

    context 'when is created with api_key' do
      before(:each) do
        ENV['SECRET_API_KEY'] = 'SECRET_API_KEY'
        request.headers['Authorization'] = 'SECRET_API_KEY'
        post :create, params: { user: user_attr }
      end

      it { expect(response.status).to eq 201 }
    end

    context 'when is not created' do
      it 'without email attr' do
        user_attr[:email] = nil
        post :create, params: { user: user_attr }
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it 'with invalid email' do
        user_attr[:email] = 'invalid_email'
        post :create, params: { user: user_attr }
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it 'with repeated email' do
        post :create, params: { user: user_attr }
        post :create, params: { user: user_attr }
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it 'with short password' do
        user_attr[:password] = '1234'
        user_attr[:password_confirmation] = '1234'
        post :create, params: { user: user_attr }
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it 'with wrong password confirmation' do
        user_attr[:password] = 'one_password'
        user_attr[:password_confirmation] = 'another_password'
        post :create, params: { user: user_attr }
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it 'returns 422' do
        user_attr[:email] = nil
        post :create, params: { user: user_attr }
        expect(response.status).to eq 422
      end

      it 'doesn\'t create user' do
        user_attr[:email] = nil
        post :create, params: { user: user_attr }
        expect do
          User.find(user_attr[:id])
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'is not created because wrong api_key' do
      before(:each) do
        ENV['SECRET_API_KEY'] = 'SECRET_API_KEY'
        request.headers['Authorization'] = 'WRONG_api_key'
        post :create, params: { user: user_attr }
      end

      it { expect(response.status).to eq 401 }
    end
  end

  describe 'DELETE /users/:id #destroy' do
    context 'when is deleted' do
      before(:each) do
        note = create :note
        note.user_id = user.id
        note.save
        signed_delete :destroy, params: { id: 'not_used' }
      end

      it 'cannot be found anymore' do
        expect do
          User.find(user.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { expect(response.status).to eq 204 }
    end

    context 'when not correctly authorized' do
      before(:each) { delete :destroy, params: { id: 'not_used' } }

      it { expect(response.status).to eq 401 }
    end
  end

  describe 'POST /users/reset_password/:token #reset_password' do
    context 'when user exists' do
      it 'returns message and calls ask_reset_password' do
        user_attr[:email] = user.email
        user_attr[:new_password] = '87654321'
        user_attr[:new_password_confirmation] = '87654321'

        expect_any_instance_of(User).to receive(:ask_reset_password).with(
          user_attr[:new_password], user_attr[:new_password_confirmation])

        post :reset_password, params: { user: user_attr }

        expect(json_response['message']).to eq I18n.t('reset_password.sent')
        expect(response.status).to eq 202
      end
    end

    context 'when users doesn\'t exist' do
      it 'returns message anyway to protect privacy' do
        user_attr[:new_password] = '87654321'
        user_attr[:new_password_confirmation] = '87654321'

        expect_any_instance_of(User).to_not receive(:ask_reset_password)

        post :reset_password, params: { user: user_attr }

        expect(json_response['message']).to eq I18n.t('reset_password.sent')
        expect(response.status).to eq 202
      end
    end

    context 'when user exists but passwords don\'t match' do
      it 'returns error message' do
        user_attr[:email] = user.email
        user_attr[:new_password] = '87654321'
        user_attr[:new_password_confirmation] = '1234'

        post :reset_password, params: { user: user_attr }

        expect(json_response['error']['message']).to include I18n.t(
          'errors.messages.confirmation', attribute: '')
        expect(json_response['error']['status']).to eq 422
        expect(response.status).to eq 422
      end
    end

    context 'when user doesn\'t exist and passwords don\'t match' do
      it 'returns error message' do
        user_attr[:new_password] = '87654321'
        user_attr[:new_password_confirmation] = '1234'

        expect_any_instance_of(User).to_not receive(:ask_reset_password)

        post :reset_password, params: { user: user_attr }

        expect(json_response['error']['message']).to include I18n.t(
          'errors.messages.confirmation', attribute: '')
        expect(json_response['error']['status']).to eq 422
        expect(response.status).to eq 422
      end
    end

    context 'when user exists but passwords are short' do
      it 'returns error message' do
        user_attr[:email] = user.email
        user_attr[:new_password] = '1234'
        user_attr[:new_password_confirmation] = '1234'

        post :reset_password, params: { user: user_attr }

        expect(json_response['error']['message']).to include I18n.t(
          'errors.messages.too_short.other', count: 8)
        expect(json_response['error']['status']).to eq 422
        expect(response.status).to eq 422
      end
    end

    context 'when user doesn\'t exist and passwords are short' do
      it 'returns error message' do
        user_attr[:email] = 'fake@email.com'
        user_attr[:new_password] = '1234'
        user_attr[:new_password_confirmation] = '1234'

        expect_any_instance_of(User).to_not receive(:ask_reset_password)

        post :reset_password, params: { user: user_attr }

        expect(json_response['error']['message']).to include I18n.t(
          'errors.messages.too_short.other', count: 8)
        expect(json_response['error']['status']).to eq 422
        expect(response.status).to eq 422
      end
    end

    context 'when email empty' do
      it 'returns error message' do
        user_attr[:email] = nil
        user_attr[:new_password] = '87654321'
        user_attr[:new_password_confirmation] = '87654321'

        expect_any_instance_of(User).to_not receive(:ask_reset_password)

        post :reset_password, params: { user: user_attr }

        expect(json_response['error']['message']).to include I18n.t(
          'errors.messages.invalid')
        expect(json_response['error']['status']).to eq 422
        expect(response.status).to eq 422
      end
    end
  end
end
