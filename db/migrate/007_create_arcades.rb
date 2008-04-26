class CreateArcades < ActiveRecord::Migration
  def self.up
    create_table :arcades do |t|
      t.timestamps
      t.string :name,                   :null => false
      t.string :phone, :website
      t.text :notes,                    :null => true
      t.belongs_to :user,               :null => true #Owner of an arcade
      t.integer :playables_count,       :default => 0
      t.integer :frequentships_count,   :default => 0
    end
    
    add_index :arcades, :name
  end

  def self.down
    drop_table :arcades
  end
end
