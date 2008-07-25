class ArcadesController < ResourceController::Base
  belongs_to :profile, :game
    
  index.wants.html { 
    if parent_type == :game
      render :template => "games/arcades" 
    elsif parent_type == :profile
      render :template => "profiles/arcades"
    else
      render :template => "arcades/index"
    end
  }

  index.wants.xml {
    render :text => @arcades.to_xml(:dasherize => false, :only => Arcade::PUBLIC_FIELDS)
  }
  
  show.wants.xml {
    render :text => @arcade.to_xml(:dasherize => false, :only => Arcade::PUBLIC_FIELDS_WITH_ADDRESS, :include => [:address], :methods => [:region, :country])
  }
  
  # Map for an arcade
  # GET /arcades/:id/map
  def map
    @arcade = Arcade.find_by_permalink(params[:id], :include => { :address => [:region, :country]} )

    @map = GMap.new("arcade_map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@arcade.address.lat, @arcade.address.lng], 13)
    @map.overlay_init(GMarker.new([@arcade.address.lat,@arcade.address.lng],
                      :title => @arcade.name,
                      :info_window => arcade_info_window(@arcade)))
  end


  def popular
    @arcades = Arcade.paginate(:all, :order => 'frequentships_count desc, playables_count desc', :include => [ { :address => :region } ], :page => params[:page], :per_page => Arcade::PER_PAGE )
    @arcades = sort_arcades_by_distance(arcades) if params[:order] == 'distance'
    @max_count = Arcade.maximum(:frequentships_count)
    @map = map_for_arcades(@arcades)
  end


  def claim
    @arcade = object
  end


  # One page form for creating a new arcade (currently doesnt work with games or address)
  def new
    @arcade = Arcade.new(params[:arcade])
  end
  
  # Step 1 of 3 for creating an arcade
  # Step 1 will setup the basics about an arcade - name, address
  def new1
    @arcade = Arcade.new(params[:arcade])
    @arcade.address = Address.new(params[:address])
    
    if request.post?
      if params[:add_hours] == "true"
        params[:hours].each do |hour|
          new_hour = Hour.new(hour)
          @arcade.hours << new_hour
        end
      end
      
      redirect_to new_arcade_2_path
    elsif request.get?
      @arcade.hours << Hour.new(:dayofweek => 'mon')
      @arcade.hours << Hour.new(:dayofweek => 'tue')
      @arcade.hours << Hour.new(:dayofweek => 'wed')
      @arcade.hours << Hour.new(:dayofweek => 'thu')
      @arcade.hours << Hour.new(:dayofweek => 'fri')
      @arcade.hours << Hour.new(:dayofweek => 'sat')
      @arcade.hours << Hour.new(:dayofweek => 'sun')
    end
  end
  
  # Review information
  def new2
    @arcade = Arcade.new(params[:arcade])
    
    if request.post?
      
      debugger
      if params[:commit_back]
        redirect_to new_arcade_1_path
      else
        redirect_to new_arcade_3_path
      end
    end
  end
  
  # Add games to a new arcade
  def new3
    @games = Game.find(:all, :order => 'name')
    
    if request.post?
      @arcade = Arcade.new(params[:arcade])
      
      if params[:commit_back]
        redirect_to new_arcade_2_path
      else
        redirect_to arcades_path
      end
    end
  end
  
  
  
  
  
  
  
  
  
  
  #Editing
  # Manage games at an existing arcade
  def edit_games
    @arcade = object
  end
  
  def edit
    @arcade = object
    @arcade.hours = Hour.create_week(@arcade) if @arcade.hours.size != 7
  end
  
  def update
    @arcade = object
    debugger
    
    @arcade.name = params[:arcade][:name]
    @arcade.address.attributes.merge!(params[:arcade][:address])
    
    if @arcade.valid?      
      flash[:notice] = "All information looks right! Please verify it's still looking good. If all is well, we'll update this location right away!"
      redirect_to review_arcade_path(@arcade)
    else
      flash[:error] = "There was an error in the form you submitted. Please fix it below."
      redirect_to edit_arcade_path(@arcade)
    end
  end


  def verify
    
  end

  
  
  
  
  
  

  
  def unfavorite
    if favorite_arcade = Frequentship.find_by_arcade_id_and_profile_id(object.id,current_profile.id)
      favorite_arcade.destroy
      flash[:notice] = "<span class=\"favorite arcade_delete\">You removed <b>#{object.name}</b> from your list of favorite arcades. <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcades</a>.</span>"
    else
      flash[:error] = "You have not added <b>#{object.name}</b> to your list of favorite arcades, so how could you remove it? <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcades</a>."
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  
  
  
  def favorite
    @arcade = object
    if !current_profile.has_favorite_arcade?(@arcade)
      current_profile.arcades << @arcade
    end

    respond_to do |format|
      format.html {
        if current_profile.arcades.include?(@arcade)
          flash[:notice] = "<span class=\"favorite arcade_add\">You added <b>#{@arcade.name}</b> to your list of favorite arcades! <a href=\"#{profile_arcade_path(current_profile)}\">View your favorite arcade</a>.</span>"
        else
          flash[:error] = "You have already added <b>#{@arcade.name}</b> to your list of favorite arcades. <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcade</a>."
        end
        redirect_to request.env["HTTP_REFERER"]
      }
      format.js {
        if current_profile.arcades.include?(@arcade)
          render
        else
          render :update do |page|
            page.alert("You have already added \"#{@arcade.name}\" to your list of favorite arcades. Try refreshing the page and trying again.")
          end
        end
      }
    end    
  end
  
  def unfavorite
    @arcade = object
    if favorite_arcade = Frequentship.find_by_arcade_id_and_profile_id(@arcade.id,current_profile.id)
      favorite_arcade.destroy
    end

    respond_to do |format|
      format.html {
        if !favorite_arcade.nil? && favorite_arcade.frozen?
          flash[:notice] = "<span class=\"favorite arcade_delete\">You removed <b>#{@arcade.name}</b> from your list of favorite arcades. <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcades</a>.</span>"
        else
          flash[:error] = "You have not added <b>#{@arcade.name}</b> to your list of favorite arcades, so how could you remove it? <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcades</a>."
        end
        redirect_to request.env["HTTP_REFERER"]
      }
      format.js {
        if !favorite_arcade.nil? && favorite_arcade.frozen?
          render
        else
          render :update do |page|
            page.alert("You have not added \"#{@arcade.name}\" to your list of favorite arcades, so you can't remove it. Try refreshing the page and trying again.")
          end
        end
      }
    end
  end
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  private
  # GET /arcades
  # GET /profiles/:profile_id/arcades
  # GET /games/:game_id/arcades
  def collection
    arcades = parent? ? parent_object.arcades.paginate(options) : Arcade.paginate(options)    
    arcades = sort_arcades_by_distance(arcades) if params[:order] == 'distance'
    @map = map_for_arcades(arcades)
    arcades
  end

  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search] 
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] || Arcade::PER_PAGE
    collection_options[:order] = params[:order] || 'arcades.name, frequentships_count desc'
    collection_options[:include] = {:address => [:region, :country]}      
    collection_options[:conditions] = ['arcades.name like ?', "#{search}%"] unless search.blank?
    collection_options
  end
  

  def parent_object
    return Game.find_by_permalink(params[:game_id]) if parent_type == :game
    return Profile.find_by_permalink(params[:profile_id]) if parent_type == :profile
  end

  # GET /arcades/1-arcade-name
  # This will set an arcade object
  def object
    arcade = Arcade.find_by_permalink(params[:id], :include => [ { :address => [:country, :region] }] )
    @map = GMap.new("arcade_map")
    @map.control_init(:map_type => false, :small_zoom => true)
    @map.center_zoom_init([arcade.address.lat, arcade.address.lng], 10)
    @map.overlay_init(GMarker.new([arcade.address.lat, arcade.address.lng], :title => arcade.name))
    arcade
  end
  


  def arcade_info_window(arcade)
    "<strong>#{arcade.name}</strong> <p>#{arcade.address.street}<br />#{arcade.address.city}, #{arcade.address.region.name} #{arcade.address.postal_code}</p><p><strong>Games:</strong> #{arcade.playables_count}</p>"
  end 
  
  # Create a map object for an array of arcades
  def map_for_arcades(arcades)
    map = GMap.new("arcades_map")
    map.control_init(:small_map => true, :map_type => false)
    map.center_zoom_init([26,-80], 13)

    markers = []
    for arcade in arcades
      markers << GMarker.new([arcade.address.lat,arcade.address.lng],
                             :title => arcade.name,
                             :info_window => arcade_info_window(arcade))
    end
    managed_markers = ManagedMarker.new(markers,0,13)

    mm = GMarkerManager.new(map,:managed_markers => [managed_markers])
    map.declare_init(mm,"arcades")

    sorted_latitudes = arcades.collect(&:address).collect(&:lat).compact.sort
    sorted_longitudes = arcades.collect(&:address).collect(&:lng).compact.sort
    map.center_zoom_on_bounds_init([ [sorted_latitudes.first, sorted_longitudes.first], 
                                      [sorted_latitudes.last, sorted_longitudes.last]])
    map
  end
  
  def sort_arcades_by_distance(arcades)
    (arcades && arcades.length > 1 && addressed_in?) ? arcades.sort_by_distance_from(current_address) : arcades
  end
end