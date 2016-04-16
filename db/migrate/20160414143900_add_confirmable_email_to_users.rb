class AddConfirmableEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :conf_token, :string
    add_column :users, :conf_at, :datetime
    add_column :users, :conf_sent_at, :datetime
    add_index :users, :conf_token, unique: true
  end
end
