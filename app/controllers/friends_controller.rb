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
      stop_being_friends
    elsif current_user.following?(parent_object)
      stop_following
    elsif current_user.follower?(parent_object)
      remove_follower
    end

    redirect_to request.env["HTTP_REFERER"]
  end
  
  private
  def add_follower
    if Friendship.add_follower(current_user, parent_object)
      flash[:notice] = "<span class=\"favorite user_add\">You have added <b>#{parent_object.login}</b> as a friend. As soon as they confirm the friend request, you will show up as friends.</span>"
    else
      flash[:error] = "There was problem adding that friend. Can you try again?"
    end
  end
  
  def make_friends
    if Friendship.make_friends(current_user, parent_object)
      flash[:notice] = "<span class=\"favorite user_add\">You are now friends with <b>#{parent_object.login}</b>!</span>"
    else
      flash[:error] = "There was problem adding that friend. Can you try again?"
    end
  end
  
  def stop_being_friends
    if Friendship.stop_being_friends(current_user, parent_object)
      flash[:notice] = "<span class=\"favorite user_delete\">You have removed <b>#{parent_object.login}</b> from your friends list.</span>"      
    else
      flash[:error] = "There was a problem removing that friend. Can you try again?"
    end
  end
  
  def stop_following
    if Friendship.stop_following(current_user, parent_object)
      flash[:notice] = "<span class=\"favorite user_delete\">You withdrew your friend request to <b>#{parent_object.login}</b>.</span>"      
    else
      flash[:error] = "There was a problem withdrawing your friend request. Can you try again?"
    end
  end
  
  def remove_follower
    if Friendship.remove_follower(current_user, parent_object)
      flash[:notice] = "<span class=\"favorite user_delete\">You declined the friend request from <b>#{parent_object.login}</b>.</span>"      
    else
      flash[:error] = "There was a problem declining that friend request. Can you try again?"
    end
  end
end