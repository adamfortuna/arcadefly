class CreatePlayables < ActiveRecord::Migration
  def self.up
    create_table :playables do |t|
      t.belongs_to :arcade, :game, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :playables
  end
end
