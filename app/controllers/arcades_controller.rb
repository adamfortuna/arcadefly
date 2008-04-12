class ArcadesController < ResourceController::Base
  belongs_to :user, :game
  
  before_filter :login_required, :only => :favorite
  
  def collection
    # GET /arcades/1/games
    if parent_type == :game
      @game = Game.find(params[:game_id], :include => 'arcades')
      @collection = @game.arcades
    # GET /users/adam/games
    elsif parent_type == :user
      @user = User.find(params[:user_id], :include => 'arcades')
      @collection = @user.arcades
    # GET /games
    else
      @collection ||=  Arcade.search(params[:search], params[:page])
    end
    @playables_count = Arcade.maximum(:playables_count) * 1.1
    #@playables_count = (@collection.collect do |r| r.playables_count end).max.to_i * 1.1
    @collection.sort_by_distance_from(current_user.address) if current_user.has_address?
  end
  
  def object
    @arcade = Arcade.find(params[:id], :include => :address)
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
      render :template => "games/arcades_list" 
    elsif parent_type == :user
      render :template => "users/arcades"
    else
      render :template => "arcades/index"
    end
  }
  
  # Additional actions
  # GET /arcades/map
  # GET /games/:game_id/arcades/map
  def list_map
    if parent?
      @game = Game.find(params[:game_id], :include => 'arcades')
      @arcades= @game.arcades
    else
      @arcades = Arcade.search(params[:search], params[:page])
    end

    @arcades.sort_by_distance_from(current_user.address) if current_user.has_address?
    
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
    unless not params[:game_id]
      respond_to do |format|
        format.html { render :template => 'games/arcades_map' }
        format.xml  { render :xml => @arcades.to_xml }
      end
    end
  end
  
  # Map for an arcade
  # GET /arcades/:id/map
  def map
    @arcade = Arcade.find(params[:id], :include => 'address')
    
    @map = GMap.new("arcade_map")
	  @map.control_init(:large_map => true, :map_type => true)
	  @map.center_zoom_init([@arcade.address.lat, @arcade.address.lng], 13)
	  @map.overlay_init(GMarker.new([@arcade.address.lat,@arcade.address.lng],
	                    :title => @arcade.name,
	                    :info_window => arcade_info_window(@arcade)))
  end

  
  def favorite
    @arcade = Arcade.find(params[:id])
    
    # POST /arcade/1-arcade-name/favorite
    if request.post?
      if !(current_user.arcades.collect do |a| a.id end).include?(@arcade.id)
        current_user.arcades.push(@arcade)
        flash[:notice] = "You added <b>#{@arcade.name}</b> to your list of favorite arcades!"
      else
          flash[:error] = "You have already added <b>#{@arcade.name}</b> to your list of favorite arcades."
      end
    elsif request.delete?
      if !(current_user.arcades.collect do |a| a.id end).include?(@arcade.id)
        flash[:error] = "You have not added <b>#{@arcade.name}</b> to your list of favorite arcades, so how could you remove it?"
      else
        current_user.arcades.delete(@arcade)
        flash[:notice] = "You removed <b>#{@arcade.name}</b> from your list of favorite arcades."
      end
    end
    redirect_to arcade_path(@arcade)
  end
  
  
  private
  def arcade_info_window(arcade)
    "<strong>#{arcade.name}</strong> <p>#{arcade.address.street}<br />#{arcade.address.city}, #{arcade.address.region.name} #{arcade.address.postal_code}</p><p><strong>Games:</strong> #{arcade.games.count}</p>"
  end 
end
