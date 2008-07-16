class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.timestamps
      t.belongs_to :profile
      t.references :commentable,  :polymorphic => true,  :null => true
      t.text     :comment
      t.integer  :is_denied,        :default => 0,     :null => false
      t.boolean  :is_reviewed,      :default => false
    end

    add_index :comments, :profile_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
  
  def self.down
    drop_table :comments
  end
end
