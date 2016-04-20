require 'spec_helper'

RSpec.describe Api::V1::UserSerializer do
  describe 'User json serialization' do
    let(:user) { build :user }
    let(:json) { Api::V1::UserSerializer.new(user).serializable_hash }

    it 'renders json correctly' do
      expect(json[:email]).to eq user.email
      expect(json.key?(:auth_token)).to be true
      expect(json.key?(:id)).to be false
      expect(json.key?(:password)).to be false
      expect(json.key?(:password_confirmation)).to be false
      expect(json.key?(:password_digest)).to be false
      expect(json.key?(:confirmation_token)).to be false
      expect(json.key?(:confirmation_at)).to be false
      expect(json.key?(:confirmation_sent_at)).to be false
      expect(json.key?(:reset_password_digest)).to be false
      expect(json.key?(:reset_password_token)).to be false
      expect(json.key?(:reset_password_sent_at)).to be false
      expect(json.key?(:created_at)).to be false
      expect(json.key?(:updated_at)).to be false
    end
  end
end
