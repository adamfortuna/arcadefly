class ArcadesController < ResourceController::Base
  belongs_to :profile, :game
  
  before_filter :login_required, :only => :favorite
  
  def collection
    # GET /games/1/arcades
    if parent_type == :game
      @game = Game.find(params[:game_id], :include => 'arcades')
      @collection = @game.arcades.paginate :page => params[:page], :order => 'arcades.name', :per_page => Arcade::PER_PAGE, :include => {:address => [:region, :country]}
    # GET /profiles/1-adam/arcades
    elsif parent_type == :profile
      @profile = Profile.find(params[:profile_id])
      @collection = @profile.arcades.paginate :page => params[:page], :order => 'arcades.name', :per_page => Arcade::PER_PAGE, :include => {:address => [:region, :country]}
    # GET /arcades/distance
    else
      @collection =  Arcade.search(params[:search], params[:page])
      @collection.sort_by_distance_from(current_address) if addressed_in? && @collection.length > 1
    end
    @collection
  end
  
  def object
    @arcade = Arcade.find(params[:id], :include => [ { :address => [:country, :region] }] )
    @map = GMap.new("arcade_map")
    @map.control_init(:map_type => false, :small_zoom => true)
    @map.center_zoom_init([@arcade.address.lat, @arcade.address.lng], 11)
    @map.overlay_init(GMarker.new([@arcade.address.lat, @arcade.address.lng], :title => @arcade.name))
    @arcade
  end
  
  # index can be called from the following:
  # GET /arcades
  # GET /games/:game_id/arcades
  index.wants.html { 
    if parent_type == :game
      render :template => "games/arcades" 
    elsif parent_type == :profile
      render :template => "profiles/arcades"
    else
      render :template => "arcades/index"
    end
  }

  def show
    @arcade = object

    @games_popularity =  Arcade.count(:conditions => ['playables_count > ?', @arcade.playables_count])+1
    @users_popularity =  Arcade.count(:conditions => ['frequentships_count > ?', @arcade.frequentships_count])+1
  end
  
  def browse
    @countries = Country.find(:all, :include => :addresses, :conditions => 'addresses.addressable_type="Arcade"', :order => 'countries.name')
    @regions = Region.find(:all, :include => :addresses, :conditions => 'addresses.addressable_type="Arcade"', :order => 'regions.name')
  end
  
  # GET /arcades/countries/:id
  # :id will be the region id
  def country
    @arcades = Arcade.search_by_country(params[:id], params[:page])
    @max_count = Arcade.maximum(:playables_count, :include => :address, :conditions => ['addresses.country_id = ?', params[:id]]) if @arcades.length > 0
    @title = Country.find(params[:id]).name
    render :template => "arcades/arcades"
  end

  # GET /arcades/regions/:id
  # :id will be the region id
  def region
    region = params[:id].to_i
    @arcades = Arcade.search_by_region(region, params[:page])
    @max_count = Arcade.maximum(:playables_count, :include => :address, :conditions => ['addresses.region_id = ?', region]) if @arcades.length > 0
    @title = Region.find(params[:id]).name
    render :template => "arcades/arcades"
  end

  def distance
    @arcades = collection
    render :template => "arcades/arcades"
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
      debugger
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
  
  
  
  def new2
    @arcade = Arcade.new(params[:arcade])
  end
  
  
  
  # Additional actions
  # GET /arcades/map
  # GET /games/:game_id/arcades/map
  # GET /user/:user_id/arcades/map
  def list_map
    if parent_type == :game
      @game = Game.find(params[:game_id])
      @arcades = @game.arcades.paginate :page => params[:page], :order => 'arcades.name', :per_page => Arcade::PER_PAGE, :include => {:address => [:region, :country]}
    elsif parent_type == :profile
      @profile = Profile.find(params[:profile_id])
      @arcades = profile.arcades.paginate :page => params[:page], :order => 'arcades.name', :per_page => Arcade::PER_PAGE, :include => {:address => [:region, :country]}
    else
      @arcades = Arcade.search(params[:search], params[:page])
    end
    
    # Default code for mapping beyond this point
    @arcades.sort_by_distance_from(current_address) if addressed_in?

    @map = GMap.new("arcades_map")
    @map.control_init(:small_map => true, :map_type => false)
    @map.center_zoom_init([26,-80], 13)
	  
	  markers = []
	  for arcade in @arcades
      markers << GMarker.new([arcade.address.lat,arcade.address.lng],
	                           :title => arcade.name,
	                           :info_window => arcade_info_window(arcade))
    end
    managed_markers = ManagedMarker.new(markers,0,13)
    
    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers])
    @map.declare_init(mm,"arcades")
    
    sorted_latitudes = @arcades.collect(&:address).collect(&:lat).compact.sort
    sorted_longitudes = @arcades.collect(&:address).collect(&:lng).compact.sort
    @map.center_zoom_on_bounds_init([ [sorted_latitudes.first, sorted_longitudes.first], 
                                      [sorted_latitudes.last, sorted_longitudes.last]])

    # Is this the an arcade listing map or a game/arcade listing map?
    if parent_type == :game
      render :template => 'games/arcades_map'
    elsif parent_type == :profile
      render :template => 'profiles/arcades_map'
    end
  end
  
  # Map for an arcade
  # GET /arcades/:id/map
  def map
    @arcade = Arcade.find(params[:id], :include => { :address => [:region, :country]} )
    
    @map = GMap.new("arcade_map")
	  @map.control_init(:large_map => true, :map_type => true)
	  @map.center_zoom_init([@arcade.address.lat, @arcade.address.lng], 13)
	  @map.overlay_init(GMarker.new([@arcade.address.lat,@arcade.address.lng],
	                    :title => @arcade.name,
	                    :info_window => arcade_info_window(@arcade)))
  end
  
  private
  def arcade_info_window(arcade)
    "<strong>#{arcade.name}</strong> <p>#{arcade.address.street}<br />#{arcade.address.city}, #{arcade.address.region.name} #{arcade.address.postal_code}</p><p><strong>Games:</strong> #{arcade.playables_count}</p>"
  end 
end
