class CreateArcades < ActiveRecord::Migration
  def self.up
    create_table :arcades do |t|
      t.string :name, :null => false
      t.string :phone, :website
      t.belongs_to :user, :null => true #Owner of an arcade
      t.integer :playables_count, :default => 0
      t.integer :frequentships_count, :default => 0
      t.timestamps
    end
    
    add_index :arcades, :name
    add_index :arcades, :user_id
    
  end

  def self.down
    drop_table :arcades
  end
end
