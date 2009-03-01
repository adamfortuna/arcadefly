class AddPendingToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :pending, :boolean, :default => true
    add_column :games, :profile_id, :integer
    Game.update_all 'pending=0, profile_id=1'
  end

  def self.down
    remove_column :games, :pending
    remove_column :games, :profile_id
  end
end
