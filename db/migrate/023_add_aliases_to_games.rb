class AddAliasesToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :alias, :string
  end

  def self.down
    remove_column :games, :alias
  end
end
