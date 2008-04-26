class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.timestamps
      t.belongs_to :country
      t.string :name,         :null => false, :limit => 50
      t.string :abbreviation, :null => false, :limit => 5
    end
    add_index :regions, [:name, :country_id],         :unique => true
    add_index :regions, [:abbreviation, :country_id], :unique => true
  end

  def self.down
    drop_table :regions
  end
end