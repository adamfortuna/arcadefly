class FeedItem < ActiveRecord::Base  
  belongs_to :item, :polymorphic => true
  has_many :feeds
  
  def partial
    item.class.name.underscore
  end
end