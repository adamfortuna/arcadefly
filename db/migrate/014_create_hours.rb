class CreateHours < ActiveRecord::Migration
  def self.up
    create_table :hours do |t|
      t.references :timeable,  :polymorphic => true,  :null => true
      t.string :dayofweek, :length => 3, :null => false # mon, tue, wed, thu, fri, sat, sun
      t.integer :day, :null => false # 0-6
      t.time :start, :end, :null => false
      t.boolean :closed, :null => false, :default => 1 # 1 = open, 0 = closed
      t.timestamps
    end
    
    add_index :hours, [:timeable_id, :timeable_type, :dayofweek], :unique
  end

  def self.down
    drop_table :hours
  end
end
