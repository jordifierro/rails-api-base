class AddUserToNotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :notes, :user, index: true, foreign_key: true
  end
end
