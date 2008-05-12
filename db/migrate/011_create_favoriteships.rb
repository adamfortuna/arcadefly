class CreateFavoriteships < ActiveRecord::Migration
  def self.up
    create_table :favoriteships do |t|
      t.belongs_to :game, :profile, :null => false
      t.timestamps
    end
    
    add_index :favoriteships, [:profile_id, :game_id], :unique
  end

  def self.down
    drop_table :favoriteships
  end
end
