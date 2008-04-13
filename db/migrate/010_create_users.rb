class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :login, :email
      t.string :crypted_password,           :limit => 40
      t.string :salt,                       :limit => 40
      t.integer :frequentships_count,       :default => 0
      t.integer :favoriteships_count,       :default => 0
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :activation_code,            :limit => 40
      t.datetime :activated_at
      t.string :password_reset_code,        :limit => 40
      t.boolean :enabled, :default => true
      t.timestamps      
    end
    
    add_index :users, :login,                       :unique => true
    add_index :users, [:login, :crypted_password]
    
    
  end

  def self.down
    drop_table "users"
  end
end
