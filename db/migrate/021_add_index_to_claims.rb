class AddIndexToClaims < ActiveRecord::Migration
  def self.up
    add_index :claims, :approved
  end

  def self.down
    remove_index :claims, :approved
  end
end
