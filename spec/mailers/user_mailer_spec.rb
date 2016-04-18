require 'spec_helper'

describe UserMailer do
  def get_message_part(mail, content_type)
    mail.body.parts.find do |p|
      p.content_type.match content_type
    end.body.raw_source
  end

  describe 'UserMailer' do
    let(:user) { create :user }
    let(:mail) { UserMailer.ask_email_confirmation(user) }

    it 'puts the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'puts the subject' do
      expect(mail.subject).to eq I18n.t('email_confirmation.subject')
    end

    it 'renders email_confirmation.ask and url on plain' do
      expect(mail.text_part.body.encoded).to match(
        I18n.t('email_confirmation.ask'))
      expect(mail.text_part.body.encoded).to match(
        users_confirm_url(user.confirmation_token))
    end

    it 'renders email_confirmation.ask, url and on html' do
      expect(mail.html_part.body.encoded).to match(
        I18n.t('email_confirmation.ask'))
      expect(mail.html_part.body.encoded).to match(
        '<a href="' + users_confirm_url(user.confirmation_token))
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type)).to match(
        ['text/plain; charset=UTF-8', 'text/html; charset=UTF-8'])
    end
  end
end
