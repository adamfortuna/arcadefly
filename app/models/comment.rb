class Comment < ActiveRecord::Base
  
  validates_presence_of :comment, :profile
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :profile

  def after_create
    feed_item = FeedItem.create(:item => self)
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
  end
  
  
  def self.between_profiles profile1, profile2
    find(:all, {
      :order => 'created_at desc',
      :conditions => [
        "(profile_id=? and commentable_id=?) or (profile_id=? and commentable_id=?) and commentable_type='Profile'",
        profile1.id, profile2.id, profile2.id, profile1.id]
    })
  end
end
