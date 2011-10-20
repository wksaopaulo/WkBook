class DeviseCreateBookAdmins < ActiveRecord::Migration
  def self.up
    create_table(:book_admins) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :book_admins, :email,                :unique => true
    add_index :book_admins, :reset_password_token, :unique => true
    # add_index :book_admins, :confirmation_token,   :unique => true
    # add_index :book_admins, :unlock_token,         :unique => true
    # add_index :book_admins, :authentication_token, :unique => true
  end

  def self.down
    drop_table :book_admins
  end
end
