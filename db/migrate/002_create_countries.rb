class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name,           :null => false, :limit => 80
      t.string :official_name,  :limit => 80
      t.string :alpha_2_code,   :null => false, :limit => 2
      t.string :alpha_3_code,   :null => false, :limit => 3
      t.string :calling_code,   :limit => 3
    end
    add_index :countries, :name,          :unique => true
    add_index :countries, :alpha_2_code,  :unique => true
    add_index :countries, :alpha_3_code,  :unique => true
  end

  def self.down
    drop_table :countries
  end
end