class Friend < ActiveRecord::Base
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'
  
  before_create :check_for_dual_friendship
  
  def validate
    errors.add('inviter', 'inviter and invited can not be the same user') if invited == inviter
  end
  
  
  def self.remove_friendship(profile, target)
    begin
      transaction do
        Friend.delete_all ["inviter_id = ? AND invited_id = ?", profile.id, target.id]
        Friend.delete_all ["inviter_id = ? AND invited_id = ?", target.id, profile.id]
      end
    rescue Exception
      return false
    end
    true
  end
  
  private
  
  def check_for_dual_friendship    
    if @friend_add = Friend.find(:first, :conditions => ["invited_id = ? AND inviter_id = ?", self.inviter_id, self.invited_id])
      self.accepted = true
      @friend_add.update_attribute(:accepted, true)
    end
  end
  
  
  
  
  
  
  
  
  # def description user, target = nil
  #   return 'friend' if status == ACCEPTED
  #   return 'follower' if user == inviter
  #   'fan'
  # end
  
  # def after_create
  #   AccountMailer.deliver_follow inviter, invited, description(inviter)
  # end
  
  
#  class << self   
#     def add_follower(inviter, invited)
#       a = Friend.create(:inviter => inviter, :invited => invited, :status => PENDING)
# #      logger.debug a.errors.inspect.blue
#       !a.new_record?
#     end
#   
#   
#     def make_friends(profile, target)
#       transaction do
#         begin
#           Friend.find(:first, :conditions => {:inviter_id => profile.id, :invited_id => target.id, :approved => true}).update_attribute(:approved, false)
#           Friend.create!(:inviter_id => target.id, :invited_id => user.id, :approved => true)
#         rescue Exception
#           return make_friends(profile, target) if profile.followed_by?(target)
#           return add_follower(target, profile)
#         end
#       end
#       true
#     end
#     
#   
#     def stop_being_friends(user, target)
#     transaction do
#       begin
#         Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id, :approved => true}).update_attribute(:approved, false)
#           f = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id, :status => ACCEPTED}).destroy
#         rescue Exception
#           return false
#         end
#       end
#       true
#     end
#     
#     
#     def reset(user, target)
#       #don't need a transaction here. if either fail, that's ok
#       begin
#         Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id}).destroy
#         Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id, :status => ACCEPTED}).update_attribute(:status, PENDING)
#       rescue Exception
#         return true # we need something here for test coverage
#       end
#       true
#     end
#   
#   
#   end
#   
end
