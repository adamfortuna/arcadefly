class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.belongs_to :role, :user, :null => false
      t.timestamps
    end
    
    add_index :permissions, [:user_id, :role_id], :unique
  end
 
  def self.down
    drop_table :permissions
  end
end