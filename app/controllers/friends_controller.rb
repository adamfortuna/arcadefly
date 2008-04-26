# Controls favoriting games and arcades.
class FriendsController < ResourceController::Base
  belongs_to :user
  before_filter :login_required
  
  def create
    current_user.follower?(parent_object) ? make_friends : add_follower
    redirect_to request.env["HTTP_REFERER"]
  end
  
  def destroy
    if current_user.friended?(parent_object)
      #debugger
      success = Friendship.stop_being_friends(current_user, parent_object)
    elsif current_user.following?(parent_object)
      #debugger
      success = Friendship.stop_following(current_user, parent_object)
    end
    
    if success
      flash[:notice] = "You have removed <b>#{parent_object.login}</b> from your friends list."
    else
      flash[:error] = "There was a problem removing that friend. Can you try again?"
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  
  private
  def add_follower
    if Friendship.add_follower(current_user, parent_object)
      flash[:notice] = "You have added <b>#{parent_object.login}</b>. As soon as they confirm the friend request, they will show up as friend of yours."
    else
      flash[:error] = "There was problem adding that friend. Can you try again?"
    end
  end
  
  def make_friends
    if Friendship.make_friends(current_user, parent_object)
      flash[:notice] = "You are not friends with<b>#{parent_object.login}</b>!"
    else
      flash[:error] = "There was problem adding that friend. Can you try again?"
    end
  end
  
end