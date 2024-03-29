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
  show.wants.xml {
    render :text => @profile.to_xml(:dasherize => false, :only => Profile::PUBLIC_FIELDS, :include => [:address], :methods => [:region, :country])
  }

  def show
    @profile = object
  end
  
  def list
    @profiles = collection
  end

#  def show
 #   @profile = object
    
    #respond_to do |format|
    #  format.html { render }
    #  format.xml { render :text => @profile.to_xml(:dasherize => false, :only => Profile::PUBLIC_FIELDS) }
    #end
  #end
  
  def edit
    @profile = object
    @user = @profile.user
  end
  
  def update
    @profile = object
    @user = @profile.user

    case params[:switch]
      when 'name'
        website_entered = !params[:profile][:website].nil? && !params[:profile][:website].blank?
        params[:profile][:website] = "http://" + params[:profile][:website] if website_entered && !(params[:profile][:website] =~ /http:\/\//)
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
        address = Address.new(params[:address])
        if address.blank?
          saved = @profile.address.destroy
        else
          @profile.address = address
          saved = @profile.address.save
        end
        if saved
          flash[:notice] = "Your address has been updated. All maps will show relative to your new address."
        else
          flash.now[:error] = "There was an error finding the address you specified. According to Google it doesn't exist. Are you sure everything is correct?"
        end
    end
    
    if @user.errors.length > 0 || @profile.errors.length > 0 || (@profile.address && @profile.address.errors.length > 0)
      flash.now[:error] ||= "There was a problem updating your profile. Errors should be highlighted in red below."
      render :action => :edit
    else
      redirect_to edit_profile_url(@profile)
    end
  end


  def destroy
    @profile = object
    
    @profile.destroy
    cookies[:auth_token] = {:expires => Time.now-1.day, :value => ""}
    session[:user] = nil
    render :update do |page|
      page.alert('Your user account, and all data, have been deleted.')
      page << 'location.href = "/";'
    end
  end





  private
  def check_permissions
    permission_denied unless current_profile == object
  end
  
  # def create_map(profile)
  #   @map = GMap.new("user_map")
  #   @map.control_init(:map_type => false, :small_zoom => true)
  #   @map.center_zoom_init([profile.address.public_lat, profile.address.public_lng], 11)
  #   @map.overlay_init(GMarker.new([profile.address.public_lat, profile.address.public_lng], :title => profile.display_name))
  # end
  
  # GET /profiles
  # GET /arcades/:arcade_id/profiles
  # GET /games/:game_id/profiles
  def collection
    if parent?
      objects = parent_object.profiles.paginate(options)
    else

      if params[:search].nil? || params[:search].blank? || params[:search].length == 1
        objects = Profile.paginate options
      else
        objects = Profile.search params[:search], :page => params[:page], :per_page => Profile::PER_PAGE, :order => params[:order] || :display_name
      end
    end
    objects
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
    collection_options = {}
    search = params[:search]
    order = params[:order]

    # Order
    order = case params[:order]
       when 'name'    then 'profiles.display_name' 
       when 'arcades' then 'frequentships_count desc'
       when 'games'   then 'favoriteships_count desc'
       else (current_session.addressed_in? && !parent?) ? 'distance' : 'profiles.display_name'
    end

    # Conditions
    collection_options[:conditions] = "profiles.active = true"
    if search == '#'
      collection_options[:conditions] += ' AND profiles.display_name regexp "^[0-9]+"'
    elsif !search.blank?
      collection_options[:conditions] += " AND (profiles.display_name like '#{search}%' OR profiles.display_name like '#{search.downcase}%')"
    end
    
    # If on the main profiles page where we map out profiles, include their addresses
    if !parent?
      collection_options[:conditions] += ' AND addresses.id IS NOT NULL' if params[:action] == 'index'
      collection_options[:include] = {:address => [:region, :country]}
      if current_session.addressed_in?
        collection_options[:origin] = current_session.address
        collection_options[:within] = current_session.profile_range if current_session.profile_range != 0
      end
    end

    # Usual params
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] if params[:per_page]
    collection_options[:order] = order

    collection_options
  end
  
end
