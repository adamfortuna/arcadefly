class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name
      t.integer :gamefaqs_id, :length => 6
      t.integer :playables_count, :default => 0
      t.integer :favoriteships_count, :default => 0
      t.timestamps
    end
    
    add_index :games, :name,          :unique => true
    add_index :games, :gamefaqs_id,  :unique => true

  end

  def self.down
    drop_table :games
  end
end
