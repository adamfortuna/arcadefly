class ArcadesController < ResourceController::Base
  belongs_to :profile, :game
  
  auto_complete_for :game, :name, :limit => 10, :order => 'playables_count DESC'
  
  before_filter :login_required, :only => [:new, :create, :favorite, :unfavorite]
  before_filter :check_administrator, :only => [:destroy]
  before_filter :check_claim, :only => [:edit, :update, :edit_games]

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
  

  # Used by an arcade goer or arcade owner to claim an arcade
  # GET /arcades/rockys-replay/claim
  def claim
    @arcade = object
  end
  
  
  # Edit an arcade
  # GET /arcades/rockys-replay/edit
  def edit
    @arcade = object
    #@arcade.hours = Hour.create_week(@arcade) if @arcade.hours.size != 7
  end
  

  # Edit the games at an arcade
  # GET /arcades/rockys-replay/games/edit
  def edit_games
    @arcade = Arcade.find_by_permalink(params[:id], :include => :playables)
    @games = Game.find(:all, :order => 'name', :limit => 100)
    
    respond_to do |format|
      format.iphone { render }
      format.html { render }
    end
  end
    

  # Map for an arcade
  # GET /arcades/:rockys-replay/map
  def map
    @arcade = Arcade.find_by_permalink(params[:id], :include => { :address => [:region, :country]} )
    @map = map_for_array([@arcade], {:large_map => true, :map_type => true, :autozoom => false})
    # @map = GMap.new("arcade_map")
    # @map.control_init(:large_map => true, :map_type => true)
    # @map.center_zoom_init([@arcade.address.lat, @arcade.address.lng], 13)
    # @map.overlay_init(GMarker.new([@arcade.address.lat,@arcade.address.lng],
    #                   :title => @arcade.name,
    #                   :info_window => @arcade.map_bubble))
  end


  # One page form for creating a new arcade (currently doesnt work with games or address)
  # GET /arcades/new
  def new
    @arcade = Arcade.new(params[:arcade])
  end
  
  # POST /arcades
  def create
    @arcade = Arcade.create(params[:arcade])
    if @arcade.valid?
      redirect_to arcade_url(@arcade)
    else
      flash[:error] = "There was a problem creating the arcade. Please fix any errors below and give it another try."
      render :action => 'new'
    end
  end
  
  # Show arcades ordered by frequenthips (user favorites)
  # GET /popular/arcades
  def popular
    @arcades = Arcade.paginate(:all, :order => 'frequentships_count desc, playables_count desc', :include => [ { :address => :region } ], :page => params[:page], :conditions => 'frequentships_count > 0')
    @arcades = sort_by_distance(arcades) if params[:order] == 'distance'
    @max_count = Arcade.maximum(:frequentships_count)
    @map = map_for_array(@arcades)
  end


  
  
  
  
  
  
  # Updating an arcade
  # PUT /arcades/rockyy-replay
  def update
    @arcade = object
    if @arcade.update_attributes(params[:arcade])
      flash[:notice] = "<span class=\"icon arcade_add\">Arcade updated! Please review the changes below and make sure everything looks as you'd expect.</span>"
      redirect_to arcade_url(@arcade)
    else
      flash[:error] = "<span class=\"icon arcade_delete\">Looks like some required information was missing. Please check below and fix any errors before going on.</span>"
      render :action => 'edit'
    end
  end


  def favorite
    @arcade = object
    if !current_profile.has_favorite_arcade?(@arcade)
      current_profile.arcades << @arcade
    end

    respond_to do |format|
      format.html {
        if current_profile.arcades && current_profile.arcades.length && current_profile.arcades.include?(@arcade)
          flash[:notice] = "<span class=\"favorite arcade_add\">You added <b>#{@arcade.name}</b> to your list of favorite arcades! <a href=\"#{profile_arcade_path(current_profile)}\">View your favorite arcade</a>.</span>"
        else
          flash[:error] = "You have already added <b>#{@arcade.name}</b> to your list of favorite arcades. <a href=\"#{profile_arcades_path(current_profile)}\">View your favorite arcade</a>."
        end
        redirect_to request.env["HTTP_REFERER"]
      }
      format.js {
        if current_profile.arcades && current_profile.arcades.length > 0 && current_profile.arcades.include?(@arcade)
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
    #arcades = sort_by_distance(arcades) #if params[:order] == 'distance'
    @map = map_for_array(arcades)
    arcades
  rescue
    []
  end

  # Setup up the possible options for getting a collection, with defaults
  def options
    order = params[:order]
    if order == 'name'
      order = 'arcades.name, frequentships_count desc' 
    elsif order == 'favorites'
      order = 'frequentships_count desc'
    elsif order == 'games'
      order = 'playables_count desc'
    elsif addressed_in?
      order = 'distance'
    else
      order = 'arcades.name, frequentships_count desc'
    end
  
    search = params[:search] 
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] if params[:per_page]
    collection_options[:order] = order
    collection_options[:include] = {:address => [:region, :country]}      
    collection_options[:conditions] = ['arcades.name like ?', "#{search}%"] unless search.blank?
    collection_options[:origin] = current_address if addressed_in?
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
  
  def check_claim
    permission_denied unless logged_in? && (current_profile.claimed?(object) || current_profile.administrator?)
  end
end