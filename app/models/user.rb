class User < ApplicationRecord
  include Concerns::Authenticatable
  include Concerns::Confirmable
  include Concerns::Recoverable

  has_many :notes
end
