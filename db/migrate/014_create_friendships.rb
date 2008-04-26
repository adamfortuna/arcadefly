class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.timestamps
      t.integer :friender_id, :null => false
      t.integer :friendee_id, :null => false
      t.integer :status,      :default => 0
    end
    
    add_index :friendships, [:friender_id, :friendee_id], :unique
    add_index :friendships, [:friendee_id, :friender_id], :unique    
  end

  def self.down
    drop_table :favoriteships
  end
end
