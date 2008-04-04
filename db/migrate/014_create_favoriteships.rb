class CreateFavoriteships < ActiveRecord::Migration
  def self.up
    create_table :favoriteships do |t|
      t.belongs_to :game, :user, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :favoriteships
  end
end
