class RenameFriendsStatus < ActiveRecord::Migration
  def self.up
    rename_column :friends, :status, :accepted
    change_column :friends, :accepted, :boolean
  end

  def self.down
    rename_column :friends, :accepted, :status
    change_column :friends, :status, :integer
  end
end
