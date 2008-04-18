class CreateHours < ActiveRecord::Migration
  def self.up
    create_table :hours do |t|
      t.references :timeable,  :polymorphic => true,  :null => true
      t.integer :dayofweek, :null => false #0-6
      t.time :start, :end
      t.timestamps
    end
    
    add_index :hours, [:timeable_id, :timeable_type], :unique
  end

  def self.down
    drop_table :hours
  end
end
