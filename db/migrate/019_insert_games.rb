class InsertGames < ActiveRecord::Migration
  def self.up
    raise if Game.count == 0
    # At this point, you'll have to login as an administrator and access the /games/update page. This will load all games from GameFaqs.
    # After that rerun the migration and this one will run.
  end

  def self.down
    execute "TRUNCATE games"
  end
end
