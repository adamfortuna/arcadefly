class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles, :force => true do |t|
      t.timestamps
      t.belongs_to :user
      t.string   :email,                      :null => false
      t.string   :display_name,               :null => false
      t.string   :full_name
      t.string   :website
      t.string   :blog
      t.text     :about_me
      t.string   :initials
      
      t.string   :aim_name
      t.string   :gtalk_name
      t.string   :msn_name
      
      t.string   :youtube_username
      t.string   :flickr_username
      t.integer  :frequentships_count,        :default => 0
      t.integer  :favoriteships_count,        :default => 0
      
      t.integer  :friendships_count,          :default => 0
      
      t.boolean  :administrator,              :null => false, :default => false      
    end

    add_index :profiles, :user_id
    add_index :profiles, :email
    add_index :profiles, :display_name
  end
end
