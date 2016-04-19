module Concerns
  module Confirmable
    extend ActiveSupport::Concern

    included do
      has_secure_token :confirmation_token

      after_create :ask_email_confirmation
    end

    private

    def ask_email_confirmation
      self.confirmation_sent_at = DateTime.current
      save
      UserMailer.ask_email_confirmation(self).deliver
    end
  end
end
