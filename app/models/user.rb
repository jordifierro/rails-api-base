class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_secure_token :confirmation_token
  has_secure_token :reset_password_token
  attr_accessor :new_password, :new_password_confirmation

  has_many :notes

  after_create :ask_email_confirmation

  validates :email, uniqueness: true, format: /@/
  validates :password, length: { minimum: 8 }, on: :create
  validates :new_password, confirmation: true, length: { minimum: 8 },
                           allow_nil: true

  def ask_reset_password(new_password, new_password_confirmation)
    self.new_password = new_password
    self.new_password_confirmation = new_password_confirmation
    self.reset_password = generate_password_digest(new_password)
    self.reset_password_sent_at = DateTime.current
    if valid?
      regenerate_reset_password_token
      save
      UserMailer.ask_reset_password(self).deliver
    end
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

  def generate_password_digest(new_password)
    current_password_digest = password_digest
    self.password = new_password
    new_password_digest = password_digest
    self.password_digest = current_password_digest
    new_password_digest
  end
end
