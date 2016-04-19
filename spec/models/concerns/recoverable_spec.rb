require 'spec_helper'

describe Concerns::Recoverable do
  let(:user) { create :user }

  describe 'responds to attrs' do
    it { expect(user).to respond_to(:reset_password_digest) }
    it { expect(user).to respond_to(:reset_password_token) }
    it { expect(user).to respond_to(:reset_password_sent_at) }
    it { expect(user).to respond_to(:new_password) }
    it { expect(user).to respond_to(:new_password_confirmation) }
  end

  describe 'validates' do
    it 'reset_password_token is unique' do
      another_user = create(:user)
      user.ask_reset_password('12345678', '12345678')
      another_user.reset_password_token = user.reset_password_token
      expect do
        another_user.save!
      end.to raise_error(ActiveRecord::RecordNotUnique)
      another_user.reset_password_token = 'different_token'
      another_user.save
      expect(another_user).to be_valid
    end
  end

  describe 'ask_reset_password' do
    it 'should have nil reset_password attrs before execute' do
      expect(user.reset_password_sent_at).to be_nil
      expect(user.reset_password_digest).to be_nil
    end

    it 'should send reset passord email and modify model if correct' do
      expect(UserMailer).to receive(:ask_reset_password).with(
        user).and_return(double('mailer', deliver: true))

      user.ask_reset_password('12345678', '12345678')

      csa = user.reset_password_sent_at.utc.to_s
      expect(csa).to eq DateTime.current.utc.to_s
      expect(user.reset_password_digest).to_not be_nil
      expect(user.reset_password_token).to_not be_nil
    end

    it 'should do nothing if wrong pass' do
      expect(UserMailer).to_not receive(:ask_reset_password).with(user)

      user.ask_reset_password('1234', '1234')

      expect(user.reset_password_sent_at).to be_nil
      expect(user.reset_password_digest).to be_nil
      expect(user.errors[:new_password]).to_not be_nil
    end

    it 'should do nothing if uncofirmed pass' do
      expect(UserMailer).to_not receive(:ask_reset_password).with(user)

      user.ask_reset_password('12345678', 'another_pass')

      expect(user.reset_password_sent_at).to be_nil
      expect(user.reset_password_digest).to be_nil
      expect(user.errors[:new_password_confirmation]).to_not be_nil
    end
  end
end
