class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  # :recoverable, :rememberable, :trackable,

  has_secure_token :auth_token
  has_secure_token :conf_token
  has_many :notes

  after_create :ask_email_confirmation

  private

  def ask_email_confirmation
    self.conf_sent_at = DateTime.current
    save
    UserMailer.ask_email_confirmation(self).deliver
  end
end
