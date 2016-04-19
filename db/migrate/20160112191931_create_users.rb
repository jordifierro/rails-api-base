class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      t.string    :email

      t.string    :password_digest
      t.string    :auth_token

      t.string    :confirmation_token
      t.datetime  :confirmation_sent_at
      t.datetime  :confirmed_at

      t.string    :reset_password
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :email,                 unique: true
    add_index :users, :auth_token,            unique: true
    add_index :users, :confirmation_token,    unique: true
    add_index :users, :reset_password_token,  unique: true
  end
end
