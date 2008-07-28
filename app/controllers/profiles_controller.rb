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

  def show
    @profile = object
    create_map(@profile) if @profile.has_address?
    
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
        if @profile.update_attributes params[:profile]
          flash[:notice] = "Your profile has been updated! These changes will take effect immediately."
        end
      when 'image'
        if @profile.update_attributes params[:profile]
          flash[:notice] = "Your avatar has been updated."
        end      
      when 'password'
        if @user.change_password(params[:verify_password], params[:user][:password], params[:user][:password_confirmation])
          flash[:notice] = "Password has been changed."
        end
      when 'address'
        if @profile.address.update_attributes params[:address]
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
    @user = object
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
    profiles = parent? ? parent_object.profiles.paginate(options) : Profile.paginate(options)
  end

  def object
    Profile.find_by_permalink(params[:id])
  end

  def parent_object
    return Game.find_by_permalink(params[:game_id]) if parent_type == :game
    return Arcade.find_by_permalink(params[:arcade_id]) if parent_type == :arcade
  end
  
  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search] 
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] || Profile::PER_PAGE
    collection_options[:order] = params[:order] || 'profiles.display_name'
    collection_options[:conditions] = ['profiles.active = 1']
    collection_options[:conditions] << ['profiles.display_name like ? OR profiles.full_name like ?', "#{search}%", "#{search}%" ] unless search.blank?
    collection_options[:conditions] << ['profiles.display_name regexp "^[0-9]+"'] if search == '#'
    collection_options
  end
  
end
