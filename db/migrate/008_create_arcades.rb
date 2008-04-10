class CreateArcades < ActiveRecord::Migration
  def self.up
    create_table :arcades do |t|
      t.string :name, :phone
      t.integer :playables_count, :default => 0
      t.integer :frequentships_count, :default => 0
      t.timestamps
    end  
  end

  def self.down
    drop_table :arcades
  end
end
