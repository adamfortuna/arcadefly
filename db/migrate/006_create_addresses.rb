class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :addressable,  :polymorphic => true,  :null => true
      t.string :title,            :null => true
      t.string :street,           :null => false
      t.string :city,             :null => false,        :limit => 255
      t.belongs_to :region,       :null => true
      t.integer :postal_code,     :null => false,        :limit => 5
      t.belongs_to :country,      :null => true,         :default => 1
      t.float :lat, :lng, :public_lat, :public_lng
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end