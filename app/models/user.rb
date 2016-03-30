class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  # :recoverable, :rememberable, :trackable,

  has_secure_token :auth_token
  has_many :notes
end
