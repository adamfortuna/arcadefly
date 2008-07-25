class CreatePlayables < ActiveRecord::Migration
  def self.up
    create_table :playables do |t|
      t.timestamps
      t.belongs_to :arcade, :game, :null => false
      t.integer :games_count, :default => 1
    end
    
    add_index :playables, [:arcade_id, :game_id], :unique
    add_index :playables, :arcade_id
    add_index :playables, :game_id
  end

  def self.down
    drop_table :playables
  end
end
