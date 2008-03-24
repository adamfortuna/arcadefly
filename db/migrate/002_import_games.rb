class ImportGames < ActiveRecord::Migration
  def self.up
    
    # Load in some sample games
    csv_file = "#{RAILS_ROOT}/db/migrate/game_data.csv"
    fields = '(gamefaqs_id, name)'

    execute "LOAD DATA INFILE '#{csv_file}' INTO TABLE games FIELDS " +
            "TERMINATED BY '|' LINES TERMINATED BY '\n' " + fields
  end

  def self.down
    execute "TRUNCATE games"
  end
end
