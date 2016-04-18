class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :confirmation_token
  has_secure_token :reset_password_token

  has_many :notes

  after_create :ask_email_confirmation

  validates :email, uniqueness: true, format: /@/
  validates :password, length: { minimum: 8 }, on: :create

  def ask_reset_password(new_password)
    current_password = password_digest
    self.password = new_password
    self.reset_password = password_digest
    self.password_digest = current_password
    self.reset_password_sent_at = DateTime.current
    regenerate_reset_password_token
    save
    UserMailer.ask_reset_password(self).deliver
  end

  def to_json(options = {})
    options[:except] ||= [:password_digest]
    super(options)
  end

  private

  def ask_email_confirmation
    self.confirmation_sent_at = DateTime.current
    save
    UserMailer.ask_email_confirmation(self).deliver
  end
end
