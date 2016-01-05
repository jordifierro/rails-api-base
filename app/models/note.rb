class Note < ApplicationRecord
  validates :title, length: { minimum: 1 }
  validates :title, length: { maximum: 20 }
end
