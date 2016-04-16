require 'spec_helper'

describe UserMailer do
  describe 'UserMailer' do
    let(:user) { create :user }
    let(:mail) { UserMailer.ask_email_confirmation(user) }

    it 'puts the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'puts the subject' do
      expect(mail.subject).to eq I18n.t('email_confirmation.subject')
    end

    it 'renders email_confirmation.ask with url' do
      expect(mail.body.encoded).to match(
        I18n.t('email_confirmation.ask',
               confirm_url: users_confirm_url(user.conf_token)))
    end
  end
end
