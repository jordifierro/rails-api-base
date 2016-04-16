class UserMailer < ApplicationMailer
  def ask_email_confirmation(user)
    @url = users_confirm_url(user.conf_token)
    mail to: user.email,
         subject: I18n.t('email_confirmation.subject')
  end
end
