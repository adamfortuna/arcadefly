class AddGamesIndex < ActiveRecord::Migration
  def self.up
    add_index :games, [:favoriteships_count, :playables_count]
    add_index :arcades, [:frequentships_count, :playables_count]
  end

  def self.down
    drop_index :games, [:favoriteships_count, :playables_count]
    drop_index :arcades, [:frequentships_count, :playables_count]
  end
end
