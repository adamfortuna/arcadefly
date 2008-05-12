class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :force => true do |t|
      t.timestamps
      t.string   :subject
      t.text     :body
      t.integer  :sender_id
      t.integer  :receiver_id
      t.boolean  :read,        :default => false, :null => false
    end
    
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
  
  def self.down
    drop_table :messages
  end
end
