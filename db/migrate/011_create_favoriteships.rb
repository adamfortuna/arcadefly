class CreateFavoriteships < ActiveRecord::Migration
  def self.up
    create_table :favoriteships do |t|
      t.belongs_to :game, :user, :null => false
      t.timestamps
    end
    
    add_index :favoriteships, [:user_id, :game_id], :unique
  end

  def self.down
    drop_table :favoriteships
  end
end
