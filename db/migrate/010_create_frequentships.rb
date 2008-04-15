class CreateFrequentships < ActiveRecord::Migration
  def self.up
    create_table :frequentships do |t|
      t.belongs_to :arcade, :user, :null => false
      t.timestamps
    end
    
    add_index :frequentships, [:user_id, :arcade_id], :unique
  end

  def self.down
    drop_table :frequentships
  end
end
