class ProfilesController < ResourceController::Base
  belongs_to :game, :arcade

  before_filter :check_permissions, :only => [:destroy, :edit, :update]
  skip_filter :login_required, :only => [:show, :index]

  index.wants.html { 
    # GET /arcades/:arcade_id/users
    if parent_type == :arcade
      render :template => "arcades/profiles" 
    # GET /games/:game_id/users
    elsif parent_type == :game
      render :template => "games/profiles"
    # GET /users
    else
      render :template => "profiles/index"
    end
  }  
  index.wants.xml { 
    render :text => @profiles.to_xml(:dasherize => false, :only => Profile::PUBLIC_FIELDS)
  }

  
  def list
    @profiles = collection
  end

  def show
    @profile = object
    
    respond_to do |format|
      format.xml { render :text => @profile.to_xml(:dasherize => false, :only => Profile::PUBLIC_FIELDS) }
      format.html { render }
    end
  end
  
  def edit
    @profile = object
    @user = @profile.user
  end
  
  def update
    @profile = object
    @user = @profile.user

    case params[:switch]
      when 'name'
        if @profile.update_attributes(params[:profile])
          flash[:notice] = "Your profile has been updated! These changes will take effect immediately."
        end
      when 'image'
        if @profile.update_attributes(params[:profile])
          flash[:notice] = "Your avatar has been updated."
        end      
      when 'password'
        if @user.change_password(params[:verify_password], params[:user][:password], params[:user][:password_confirmation])
          flash[:notice] = "Password has been changed."
        end
      when 'address'
        @profile.build_address unless @profile.address
        if @profile.address.update_attributes(params[:address])
          flash[:notice] = "Your address has been updated. All maps will show relative to your new address."
        end
    end
    
    if @user.errors.length > 0 || @profile.errors.length > 0
      flash.now[:error] = "There was a problem updating your profile. Errors should be highlighted in red below."
      render :action => :edit
    else
      redirect_to edit_profile_url(@profile)
    end
  end


  def destroy
    @profile = object
    respond_to do |wants|
     @profile.destroy
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
  def check_permissions
    permission_denied unless current_profile == object
  end
  
  def create_map(profile)
    @map = GMap.new("user_map")
    @map.control_init(:map_type => false, :small_zoom => true)
    @map.center_zoom_init([profile.address.public_lat, profile.address.public_lng], 11)
    @map.overlay_init(GMarker.new([profile.address.public_lat, profile.address.public_lng], :title => profile.display_name))
  end
  
  # GET /profiles
  # GET /arcades/:arcade_id/profiles
  # GET /games/:game_id/profiles
  def collection
    if parent?
      parent_object.profiles.paginate(options)
    else
      if params[:search].nil? or params[:search].length == 1
        objects = Profile.paginate options
      else
        objects = Profile.search params[:search], :page => params[:page], :per_page => Profile::PER_PAGE, :order => :display_name
      end
    end
  end

  def object
    @object ||= Profile.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound if @object.nil?
    @object
  end

  def parent_object
    return @parent_object if @parent_object
    @parent_object = Game.find_by_permalink(params[:game_id]) if parent_type == :game
    @parent_object = Arcade.find_by_permalink(params[:arcade_id]) if parent_type == :arcade
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
  
  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search]

    order = params[:order]
    if order == 'name'
      order = 'profiles.display_name' 
    elsif order == 'arcades'
      order = 'frequentships_count desc'
    elsif order == 'games'
      order = 'favoriteships_count desc'
    elsif current_session.addressed_in? && params[:action] == 'index'
      order = 'distance'
    else
      order = 'profiles.display_name'
    end


    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] if params[:per_page]
    collection_options[:order] = order
    collection_options[:conditions] = ['profiles.active = 1']
    if search == '#'
      collection_options[:conditions] << ['profiles.display_name regexp "^[0-9]+"']
    elsif !search.blank?
      collection_options[:conditions] << ['profiles.display_name like ?', "#{search}%"]
    end

    if params[:action] == 'index'
      collection_options[:conditions] << ['addresses.id IS NOT NULL']
      collection_options[:include] = {:address => [:region, :country]}
      if current_session.addressed_in?
        collection_options[:origin] = current_session.address
        collection_options[:within] = current_session.profile_range
      # else
      #   collection_options[:origin] = Address.first
      #   collection_options[:within] = 50000
      end
    end

    collection_options
  end
  
end
