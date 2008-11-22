class ArcadesController < ResourceController::Base
  belongs_to :profile, :game
  
  auto_complete_for :game, :name, :limit => 10, :order => 'playables_count DESC'
  
  before_filter :check_near, :only => [:index]
  before_filter :login_required, :only => [:new, :create, :favorite, :unfavorite]
  before_filter :check_administrator, :only => [:destroy]
  before_filter :check_claim, :only => [:edit, :update, :edit_games]
  before_filter :set_arcade, :only => :claim

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
  # def claim; end 

  # def show
  #     @arcade = object
  #   end

  # Edit an arcade
  # GET /arcades/rockys-replay/edit
  def edit
    @arcade = object
    #@arcade.hours = Hour.create_week(@arcade) if @arcade.hours.size != 7
  end
  

  # Edit the games at an arcade
  # GET /arcades/rockys-replay/games/edit
  def edit_games
    @arcade = Arcade.find_by_permalink(params[:id])
    respond_to do |format|
      format.iphone { render }
      format.html { render }
    end
  end
    

  # Map for an arcade
  # GET /arcades/:rockys-replay/map
  def map
    @arcade = Arcade.find_by_permalink(params[:id], :include => { :address => [:region, :country]} )
  end


  # One page form for creating a new arcade (currently doesnt work with games or address)
  # GET /arcades/new
  def new
    @arcade = Arcade.new
    @arcade.build_week
  end
  
  # POST /arcades
  def create
    @arcade = Arcade.create(params[:arcade].merge(:profile => current_session.profile, :address => Address.new(params[:arcade][:address])))
    if @arcade.valid?
      redirect_to arcade_url(@arcade)
    else
      if !@arcade.address || @arcade.address.errors.on(:lat)
        flash[:error] = "We can't find the address you entered. Please make sure it looks right and try again. If in doubt just leave out the city and we'll find it for you."
      else
        flash[:error] = "There was a problem creating the arcade. Please fix any errors below and give it another try."
      end
      @arcade.build_week unless @arcade.has_hours?
      render :action => 'new'
    end
  end
  
  # Show arcades ordered by frequenthips (user favorites)
  # GET /popular/arcades
  def popular
    @arcades = Arcade.paginate(:all,
                               :order => 'frequentships_count desc, playables_count desc',
                               :include => [ { :address => :region } ], 
                               :page => params[:page],
                               :conditions => 'frequentships_count > 0')
  end


  
  
  
  
  
  
  # Updating an arcade
  # PUT /arcades/rockys-replay
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
  
  
  def list
    @arcades = collection
  end

  private
  # GET /arcades
  # GET /profiles/:profile_id/arcades
  # GET /games/:game_id/arcades
  def collection
    parent? ? parent_object.arcades.paginate(options) : Arcade.paginate(options)
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
    elsif current_session.addressed_in?
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
    if current_session.addressed_in?
      collection_options[:origin] = current_session.address
      #collection_options[:within] = current_session.arcade_range
    end
    collection_options
  end
  

  def parent_object
    return @parent_object if @parent_object
    @parent_object = Game.find_by_permalink(params[:game_id]) if parent_type == :game
    @parent_object = Profile.find_by_permalink(params[:profile_id]) if parent_type == :profile
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end

  # GET /arcades/1-arcade-name
  # This will set an arcade object
  def object
    @object ||= Arcade.find_by_permalink(params[:id], :include => [ { :address => [:country, :region] }] )
    raise ActiveRecord::RecordNotFound if @object.nil?
    @object
  end
  
  def check_claim
    permission_denied unless logged_in? && (current_profile.claimed?(object) || current_profile.administrator?)
  end
  
  def check_near
    if params[:near]
      if params[:near] == 'me'
        address = Address.iplookup(request.env['REMOTE_ADDR'])
        current_session.address = address if address.success
      else
        current_session.address = Address.geocode(params[:near])
      end
      current_session.arcade_range = 0 if current_session.address
    end
  end
  
  def set_arcade
    @arcade = object
  end

end