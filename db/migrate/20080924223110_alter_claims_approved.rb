class AlterClaimsApproved < ActiveRecord::Migration
  def self.up
    change_column :claims, :approved, :boolean, {:default => false }
  end

  def self.down
    change_column :claims, :approved, :integer, {:default => 0 }
  end
end
