class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items, :force => true do |t|
      t.timestamps
      t.references :item,  :polymorphic => true,  :null => true
      t.boolean  :include_comments, :default => false, :null => false
      t.boolean  :is_public,        :default => false, :null => false
    end

    add_index :feed_items, [:item_id, :item_type]
  end
  
  def self.down
    drop_table :feed_items
  end
end