class AddArcadeOwners < ActiveRecord::Migration
  def self.up
    add_column :arcades, :owner_email, :string
    add_column :arcades, :owner_name, :string
  end

  def self.down
    remove_column :arcades, :owner_email
    remove_column :arcades, :owner_name
  end
end
