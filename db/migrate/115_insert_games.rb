class InsertGames < ActiveRecord::Migration
  def self.up
    raise if Game.count == 0
  end

  def self.down
    execute "TRUNCATE games"
  end
end
