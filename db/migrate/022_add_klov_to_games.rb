class AddKlovToGames < ActiveRecord::Migration
  def self.up
    change_column :games, :gamefaqs_id, :string, {:null => true}
    add_column :games, :klov_id, :string
    add_index :games, :klov_id,  :unique => true
  end

  def self.down
    change_column :games, :gamefaqs_id, :integer, {:null => false}
    remove_column :games, :klov_id
  end
end
