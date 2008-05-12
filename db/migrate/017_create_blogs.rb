class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs, :force => true do |t|
      t.timestamps
      t.string     :title
      t.text       :body
      t.belongs_to :profile
    end

    add_index :blogs, :profile_id
  end
  
  def self.down
    drop_table :blogs
  end
end
