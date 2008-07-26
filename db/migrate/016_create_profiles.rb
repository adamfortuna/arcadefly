class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles, :force => true do |t|
      t.timestamps
      t.belongs_to :user

      # From User, here for speed
      t.boolean  :active,                     :null => false, :default => false
      t.boolean  :administrator,              :null => false, :default => false
      t.string   :email,                      :null => false

      t.string   :display_name,               :null => false
      t.string   :permalink,                  :null => false
      t.string   :initials
      t.string   :full_name
      t.string   :website
      t.text     :about_me
      
      t.string   :aim_name
      t.string   :gtalk_name
      t.string   :msn_name
      
      t.integer  :frequentships_count,        :default => 0
      t.integer  :favoriteships_count,        :default => 0
      t.integer  :friendships_count,          :default => 0
      
      t.integer  :messages_count,             :default => 0, :null => false
      t.integer  :unread_messages_count,      :default => 0, :null => false
    end

    add_index :profiles, :user_id
    add_index :profiles, :email
    add_index :profiles, :display_name
    add_index :profiles, :permalink,  :unique => true
  end
end
