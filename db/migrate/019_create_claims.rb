class CreateClaims < ActiveRecord::Migration
  def self.up
    create_table :claims do |t|
      t.timestamps
      t.belongs_to :profile
      t.belongs_to :arcade
      t.integer :level, :default => 1
      t.integer :approved, :default => 0
      t.string :name
      t.text :reason
    end
    
    add_index :claims, [:profile_id, :arcade_id], :unique
    add_index :claims, [:profile_id, :arcade_id, :approved]
  end

  def self.down
    drop_table :claims
  end
end