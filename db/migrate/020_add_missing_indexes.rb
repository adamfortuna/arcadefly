class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :games, :playables_count
    add_index :games, :favoriteships_count
    
    add_index :games, [:name, :playables_count]
    add_index :games, [:name, :favoriteships_count]
    
    add_index :arcades, :playables_count
    add_index :arcades, :frequentships_count
    
    add_index :arcades, [:name, :frequentships_count]
    add_index :arcades, [:name, :playables_count]
  end

  def self.down
  end
end
