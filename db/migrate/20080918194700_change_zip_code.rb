class ChangeZipCode < ActiveRecord::Migration
  def self.up
    change_column :addresses, :postal_code, :string
  end

  def self.down
    change_column :addresses, :postal_code, :integer
  end
end
