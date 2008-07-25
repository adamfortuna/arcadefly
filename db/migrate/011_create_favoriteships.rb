class CreateFavoriteships < ActiveRecord::Migration
  def self.up
    create_table :favoriteships do |t|
      t.belongs_to :game, :profile, :null => false
      t.timestamps
    end
    
    add_index :favoriteships, [:profile_id, :game_id], :unique
    add_index :favoriteships, :profile_id
    add_index :favoriteships, :game_id
  end

  def self.down
    drop_table :favoriteships
  end
end
