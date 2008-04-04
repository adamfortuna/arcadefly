class CreateFrequentships < ActiveRecord::Migration
  def self.up
    create_table :frequentships do |t|
      t.belongs_to :arcade, :user, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :frequentships
  end
end
