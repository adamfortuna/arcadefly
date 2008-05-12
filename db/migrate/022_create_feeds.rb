class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds, :force => true do |t|
      t.timestamps
      t.belongs_to :profile, :feed_item, :null => false
    end
    
    add_index :feeds, [:profile_id, :feed_item_id]
  end
  
  def self.down
    drop_table :feeds
  end
end
