require 'spec_helper'

describe User do
  let(:user) { create :user }

  describe 'includes' do
    it { expect(User.include?(Concerns::Authenticatable)).to be true }
    it { expect(User.include?(Concerns::Confirmable)).to be true }
    it { expect(User.include?(Concerns::Recoverable)).to be true }
  end

  describe 'responds to attrs' do
    it { expect(user).to respond_to(:notes) }
    it { expect(user).to be_valid }
  end
end
