class Note < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
end
