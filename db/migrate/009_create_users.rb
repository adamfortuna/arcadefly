class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.timestamps
      t.string   :email,                      :null => false
      t.string   :new_email
      t.string   :crypted_password,           :limit => 40
      t.string   :salt,                       :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :activation_code,            :limit => 40
      t.datetime :activated_at
      t.string   :password_reset_code,        :limit => 40
      t.boolean  :enabled,                    :default => true
      t.boolean  :administrator,              :default => false, :null => false
      t.boolean  :can_send_messages,          :default => true
      t.string   :time_zone,                  :default => "UTC"
    end
    
    add_index :users, :email, :unique => true
    add_index :users, [:email, :crypted_password]
  end

  def self.down
    drop_table :users
  end
end
