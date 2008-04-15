class CreatePlayables < ActiveRecord::Migration
  def self.up
    create_table :playables do |t|
      t.belongs_to :arcade, :game, :null => false
      t.integer :update_playables_count, :default => 1
      t.timestamps
    end
    
    add_index :playables, [:arcade_id], :unique
    add_index :playables, [:game_id], :unique
    add_index :playables, [:arcade_id, :game_id], :unique
  end

  def self.down
    drop_table :playables
  end
end
