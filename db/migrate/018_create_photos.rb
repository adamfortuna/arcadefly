class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos, :force => true do |t|
      t.timestamps
      t.belongs_to :profile
      t.string     :caption,    :limit => 1000
      t.string     :image
    end

    add_index :photos, :profile_id
  end
  
  def self.down
    drop_table :photos
  end
end