class FriendsController < ApplicationController
  before_filter :get_profile
  skip_before_filter :login_required, :only => :index
  
  def show
    @friends = @profile.friends.paginate :per_page => Profile::PER_PAGE, :page => params[:page]
    @followers = @profile.followers.paginate :per_page => Profile::PER_PAGE, :page => params[:page]
    render :template => "profiles/friends"
  end
  
  # POST /profiles/:profile_id/favorite
  def create
    current_profile.friend!(@profile)
    
    respond_to do |format|
      format.html { request.env["HTTP_REFERER"] }
      format.js { 
        if current_profile.networked_with?(@profile)
          render
        else
          render :update do |page|
            page.alert("Something went wrong while adding \"#{@profile.display_name}\" as a friend. Try refreshing this page and trying again.")
          end
        end
      }
    end
    
  end
  
  # DELETE /profiles/:profile_id/favorite  
  def destroy
    current_profile.unfriend!(@profile)
    
    respond_to do |format|
      format.html { request.env["HTTP_REFERER"] }
      format.js { 
        if !current_profile.networked_with?(@profile)
          render
        else
          render :update do |page|
            page.alert("Something went wrong while removing \"#{@profile.display_name}\" as a friend. Try refreshing this page and trying again.")
          end
        end
      }
    end
  end
  
  
  protected
  
  # Profile to add as a friend
  def get_profile
    @profile = Profile.find_by_permalink(params[:profile_id])
  end
  
end
