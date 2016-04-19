require 'spec_helper'

describe Concerns::Confirmable do
  let(:user) { create :user }

  describe 'responds to attrs' do
    it { expect(user).to respond_to(:confirmation_token) }
    it { expect(user).to respond_to(:confirmation_sent_at) }
    it { expect(user).to respond_to(:confirmed_at) }
  end

  describe 'validates' do
    it 'confirmation_token is unique' do
      another_user = create(:user)
      another_user.confirmation_token = user.confirmation_token
      expect do
        another_user.save!
      end.to raise_error(ActiveRecord::RecordNotUnique)
      another_user.confirmation_token = 'different_token'
      another_user.save
      expect(another_user).to be_valid
    end
  end

  describe 'after create' do
    it 'should set confirmation_sent_at and call user_mailer' do
      expect(user.confirmation_token).to_not be_nil
      new_user = build :user
      expect(UserMailer).to receive(:ask_email_confirmation).with(
        new_user).and_return(double('mailer', deliver: true))

      new_user.save

      csa = new_user.confirmation_sent_at.utc.to_s
      expect(csa).to eq DateTime.current.utc.to_s
    end
  end
end
