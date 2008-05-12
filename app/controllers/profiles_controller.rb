class ProfilesController < ResourceController::Base
  belongs_to :game, :arcade
  
  include ApplicationHelper
    
  before_filter :setup, :except => [:index, :search]
  before_filter :search_results, :only => [:index, :search]
  skip_filter :login_required, :only=>[:show, :index, :feed, :search]

  def collection
    # GET /arcades/1-disney/users
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id], :include => 'profiles')
      @collection = @arcade.profiles.paginate :page => params[:page], :order => 'display_name', :per_page => Profile::PER_PAGE
    #GET /games/1-ABC/users
    elsif parent_type == :game
      @game = Game.find(params[:game_id], :include => 'profiles')
      @collection = @game.profiles.paginate :page => params[:page], :order => 'display_name', :per_page => Profile::PER_PAGE
    # GET /users
    else
      @collection = Profile.search(params[:search], params[:page])
    end
    @collection
  end

  def object
    User.find(param, :include => { :address => [:region, :country] })
  end

  index.wants.html { 
    # GET /arcades/:arcade_id/users
    if parent_type == :arcade
      render :template => "arcades/profiles" 
    # GET /games/:game_id/users
    elsif parent_type == :game
      render :template => "games/profiles"
    # GET /users
    else
      render :template => "profiles/search"
    end
  }
  
  
  def show
    unless @profile.youtube_username.blank?
      begin
        client = YouTubeG::Client.new
        @video = client.videos_by(:user => @profile.youtube_username).videos.first
      rescue Exception, OpenURI::HTTPError
      end
    end
    
    begin
      @flickr = @profile.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(@profile.flickr_username))
    rescue Exception, OpenURI::HTTPError
      @flickr = []
    end
      
      

    @comments = @profile.comments.paginate(:page => @page, :per_page => @per_page)
    
    respond_to do |wants|
      wants.html do
        @feed_items = @profile.feed_items
      end
      wants.rss do 
        @feed_items = @profile.feed_items
        render :layout => false
      end
    end
  end
  
  def search
    render
  end
  
  def edit
    render
  end
    
  
  def update
    case params[:switch]
    when 'name','image'
      if @profile.update_attributes params[:profile]
        flash[:notice] = "Settings have been saved."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @profile.errors
        render :action => :edit
      end
    when 'password'
      if @user.change_password(params[:verify_password], params[:new_password], params[:confirm_password])
        flash[:notice] = "Password has been changed."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @user.errors
        render :action=> :edit
      end
    else
      RAILS_ENV == 'test' ? render( :text=>'') : raise( 'Unsupported swtich in action')
    end
  end


  def delete_icon
    respond_to do |wants|
      @p.update_attribute :icon, nil
      wants.js {render :update do |page| page.visual_effect 'Puff', 'profile_icon_picture' end  }
    end      
  end



  def destroy
    respond_to do |wants|
     @user.destroy
      cookies[:auth_token] = {:expires => Time.now-1.day, :value => ""}
      session[:user] = nil
      wants.js do
        render :update do |page| 
          page.alert('Your user account, and all data, have been deleted.')
          page << 'location.href = "/";'
        end
      end
    end
  end





  private
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:show, :index, :search]
  end
  
  def setup
    @profile = Profile[params[:id]]
    @user = @profile.user
  end
  
  def search_results
    if params[:search]
      p = params[:search].dup
    else
      p = []
    end
    @results = Profile.search((p.delete(:q) || ''), p).paginate(:page => @page, :per_page => @per_page)
  end
end
