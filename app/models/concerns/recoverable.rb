module Concerns
  module Recoverable
    extend ActiveSupport::Concern

    included do
      has_secure_token :reset_password_token

      attr_accessor :new_password, :new_password_confirmation
      validates :new_password, confirmation: true, length: { minimum: 8 },
                               allow_nil: true
    end

    def ask_reset_password(new_password, new_password_confirmation)
      self.new_password = new_password
      self.new_password_confirmation = new_password_confirmation
      self.reset_password = generate_password_digest(new_password)
      if valid?
        regenerate_reset_password_token
        self.reset_password_sent_at = DateTime.current
        UserMailer.ask_reset_password(self).deliver if save
      else
        self.reset_password = nil
      end
    end

    private

    def generate_password_digest(new_password)
      current_password_digest = password_digest
      self.password = new_password
      self.password_confirmation = new_password
      new_password_digest = password_digest
      self.password_digest = current_password_digest
      new_password_digest
    end
  end
end
