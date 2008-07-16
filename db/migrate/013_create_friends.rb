class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.timestamps
      t.integer :inviter_id, :null => false
      t.integer :invited_id, :null => false
      t.integer :status,     :default => 0
    end
    
    add_index :friends, [:inviter_id, :invited_id], :unique    
  end

  def self.down
    drop_table :friends
  end
end