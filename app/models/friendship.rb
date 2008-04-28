class Friendship < ActiveRecord::Base
  
  belongs_to :friender, :class_name => 'User'
  belongs_to :friendee, :class_name => 'User'
  
  # Statuses Array
  ACCEPTED = 1
  PENDING = 0
      
  def validate
    errors.add('inviter', 'inviter and invited can not be the same user') if friendee == friender
  end
  
  def description user, target = nil
    return 'friend' if status == ACCEPTED
    return 'follower' if user == friender
    'fan'
  end
  
  #def after_create
  #  AccountMailer.deliver_follow inviter, invited, description(inviter)
  #end
  
  
  class << self
    # Starts a friends friend request
    def add_follower(friender, friendee)
      a = Friendship.create(:friender => friender, :friendee => friendee, :status => PENDING)
      !a.new_record?
    end
  
    # Called when the friendee accepts the friender as a friend. Insert the second row and update the first
    def make_friends(user, target)
      transaction do
        begin
          Friendship.find(:first, :conditions => {:friender_id => user.id, :friendee_id => target.id, :status => PENDING}).update_attribute(:status, ACCEPTED)
          Friendship.create!(:friender_id => target.id, :friendee_id => user.id, :status => ACCEPTED)
        rescue Exception
          return make_friends(target, user) if user.follower?(target)
          return add_follower(user, target)
        end
      end
      true
    end
    
    def stop_following(user, target)
      Friendship.find(:first, :conditions => {:friender_id => user.id, :friendee_id => target.id, :status => PENDING}).destroy      
      true
    rescue
      false
    end
    
    def remove_follower(user, target)
      Friendship.find(:first, :conditions => {:friender_id => target.id, :friendee_id => user.id, :status => PENDING}).destroy
      true
    rescue
      false
    end
    
    # If one user unfriends the other, update the other to follower status
    def stop_being_friends(user, target)
      transaction do
        begin
          #Friendship.find(:first, :conditions => {:friender_id => target.id, :friendee_id => user.id, :status => ACCEPTED}).update_attribute(:status, PENDING)
          Friendship.find(:first, :conditions => {:friender_id => target.id, :friendee_id => user.id, :status => Friendship::ACCEPTED}).destroy
          Friendship.find(:first, :conditions => {:friender_id => user.id, :friendee_id => target.id, :status => Friendship::ACCEPTED}).destroy
        rescue Exception
          return false
        end
      end
      true
    end
    
    def reset(user, target)
      #don't need a transaction here. if either fail, that's ok
      begin
        Friendship.find(:first, :conditions => {:friender_id => user.id, :friendee_id => target.id}).destroy
        Friendship.find(:first, :conditions => {:friender_id => target.id, :friendee_id => user.id, :status => ACCEPTED}).update_attribute(:status, PENDING)
      rescue Exception
        return true # we need something here for test coverage
      end
      true
    end
  end
end