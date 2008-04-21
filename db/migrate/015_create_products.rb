class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.belongs_to :game, :null => false
      t.string  :name, :limit => 255
      t.decimal :purchase_price, :precision => 10, :scale => 2
      t.decimal :sale_price, :precision => 10, :scale => 2
      t.integer :parent_id
      t.string  :content_type, :filename, :thumbnail
      t.integer :size, :width, :height
    end
  end

  def self.down
    drop_table :products
  end
end