class UserMailer < ApplicationMailer
  def ask_email_confirmation(user)
    @url = users_confirm_url(user.confirmation_token)
    mail to: user.email,
         subject: I18n.t('email_confirmation.subject')
  end

  def ask_reset_password(user)
    @url = users_confirm_reset_url(user.reset_password_token)
    mail to: user.email,
         subject: I18n.t('reset_password.subject')
  end
end
