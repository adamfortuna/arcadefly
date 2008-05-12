class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles, :force => true do |t|
      t.timestamps
      t.belongs_to :user
      t.string   :display_name,               :null => false
      t.string   :email,                      :null => false
      t.string   :full_name
      t.string   :website
      t.string   :blog
      t.text     :about_me
      
      t.string   :aim_name
      t.string   :gtalk_name
      t.string   :msn_name
      t.string   :ichat_name
      
      t.string   :icon
      t.string   :youtube_username
      t.string   :flickr_username
      t.integer  :frequentships_count,        :default => 0
      t.integer  :favoriteships_count,        :default => 0
      
      t.integer  :friendships_count,          :default => 0
      t.integer  :follower_friends_count,     :default => 0
      t.integer  :following_friends_count,    :default => 0
      
      t.boolean  :administrator,              :null => false, :default => true      
      
    end

    add_index :profiles, :user_id
  end
end
