class GamesController < ResourceController::Base
  belongs_to :arcade, :profile
  
  before_filter :check_administrator, :only => [:destroy, :edit, :update, :pending, :approve]
  before_filter :clean_for_db, :only => [:create, :update]
  before_filter :login_required, :only => [:new, :create]
  
  
  # This controls what views will be used depending on where the request is from.
  index.wants.html {
    # GET /arcades/:arcade_id/games
    if parent_type == :arcade
      render :template => "arcades/games" 
    # GET /users/:user_id/games
    elsif parent_type == :profile
      render :template => "profiles/games" 
    # GET /games
    else
      render :template => "games/index"
    end
  }

  index.wants.xml {
    if @games.length > 0 && @games.first.is_a?(Game)
      render :text => @games.to_xml(:dasherize => false, :only => Game::PUBLIC_FIELDS)
    else
      games = @games.collect(&:game)
      render :text => parent_object.to_xml(:dasherize => false, :include => :games, :only => Game::PUBLIC_FIELDS)
      
    end
  }
  index.wants.json {
    if @games.length > 0 && @games.first.is_a?(Game)
      render :text => @games.to_json(:only => Game::PUBLIC_FIELDS)
    else
      games = @games.collect(&:game)
      render :text => parent_object.to_json(:include => :games, :only => Game::PUBLIC_FIELDS)
      
    end
  }
  
  show.wants.xml {
    render :text => @game.to_xml(:dasherize => false, :only => Game::PUBLIC_FIELDS)
  }
  show.wants.json {
    render :text => @game.to_json(:only => Game::PUBLIC_FIELDS)
  }
    
  def popular
    @games = Game.paginate(:all, :order => 'favoriteships_count desc, playables_count desc', :page => params[:page], :conditions => ['favoriteships_count > 0'])
  end
  
  # def show
  #   @game = object
  # end

  def autocomplete_name
    games = Game.find(:all, :select => 'name', :conditions => ["LOWER(name) like ?", "%#{params[:game][:name].downcase}%"], :order => 'playables_count desc')
    render :text => games.collect { |game| game.name + "\n" }
  end
  
  def new
    @game = Game.new
  end
  
  def favorite
    @game = object
    if !current_profile.has_favorite_game?(@game)
      current_profile.games << @game
    end

    respond_to do |format|
      format.html {
        if current_profile.games && current_profile.games.length > 0 && current_profile.games.include?(@game)
          flash[:notice] = "<span class=\"favorite game_add\">You added <b>#{@game.name}</b> to your list of favorite games! <a href=\"#{profile_games_path(current_profile)}\">View your favorite games</a>.</span>"
        else
          flash[:error] = "You have already added <b>#{@game.name}</b> to your list of favorite games. <a href=\"#{profile_games_path(current_profile)}\">View your favorite games</a>."
        end
        redirect_to request.env["HTTP_REFERER"]
      }
      format.js {
        if current_profile.games && current_profile.games.length > 0 && current_profile.games.include?(@game)
          render
        else
          render :update do |page|
            page.alert("You have already added \"#{@game.name}\" to your list of favorite games. Try refreshing the page and trying again.")
          end
        end
      }
    end    
  end
  
  def unfavorite
    @game = object
    if favorite_game = Favoriteship.find_by_game_id_and_profile_id(@game.id,current_profile.id)
      favorite_game.destroy
    end

    respond_to do |format|
      format.html {
        if !favorite_game.nil? && favorite_game.frozen?
          flash[:notice] = "<span class=\"favorite game_delete\">You removed <b>#{@game.name}</b> from your list of favorite games. <a href=\"#{profile_games_path(current_profile)}\">View your favorite games</a>.</span>"
        else
          flash[:error] = "You have not added <b>#{@game.name}</b> to your list of favorite games, so how could you remove it? <a href=\"#{profile_games_path(current_profile)}\">View your favorite games</a>."   
        end
        redirect_to request.env["HTTP_REFERER"]
      }
      format.js {
        if !favorite_game.nil? && favorite_game.frozen?
          render
        else
          render :update do |page|
            page.alert("You have not added \"#{@game.name}\" to your list of favorite games, so you can't remove it. Try refreshing the page and trying again.")
          end
        end
      }
    end
  end
  
  def pending
    @games = Game.find(:all, :conditions => ["pending=?", true])
  end
  def approve_selected
    games = Game.find_all_by_id(params[:pending_games].keys, :conditions => ["pending=?", true])

    games.each do |game|
      game.approve!
    end

    flash[:notice] = "Games approved!"
    redirect_to pending_games_path
  rescue
    flash[:error] = "An error occured approving (at least some) of these games."
    redirect_to games_path    
  end
  def delete_selected
    games = Game.find_all_by_id(params[:pending_games].keys, :conditions => ["pending=?", true])
    
    games.each do |game|
      game.destroy
    end
    
    flash[:notice] = "Games removed!"
    redirect_to games_path
  rescue
    flash[:error] = "An error occured removing these games."
    redirect_to games_path
  end
  
  
  private
  
  def object
    @object ||= Game.find_by_permalink(params[:id], :conditions => ["(pending=? OR profile_id=?) OR ?", false, (logged_in? ? current_profile.id : 0), administrator?])
    raise ActiveRecord::RecordNotFound if @object.nil?
    @object
  end
  
  def parent_object
    return @parent_object if @parent_object
    @parent_object = Profile.find_by_permalink(params[:profile_id]) if parent_type == :profile
    @parent_object = Arcade.find_by_permalink(params[:arcade_id]) if parent_type == :arcade
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
  
  def collection
    if parent_type == :arcade
      objects = parent_object.playables.paginate(options)
    elsif parent_type == :profile
      objects = parent_object.favoriteships.paginate(options)
    else
      if params[:search].nil? || params[:search].blank? || params[:search].length == 1
        objects = Game.paginate options
      else
        objects = Game.search params[:search], :page => params[:page], :per_page => params[:per_page] || Game::PER_PAGE, :order => :name
      end
    end
    objects
  rescue
    []
  end
    
  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search]
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:include] = :game if parent_type == :arcade || parent_type == :profile
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] || Game::PER_PAGE
    collection_options[:order] = params[:order] || 'games.name'
    if search == '#'
      collection_options[:conditions] = ['games.name regexp "^[0-9]+"']
    elsif !search.blank?
      collection_options[:conditions] = ['(games.name like ? OR games.name like ?)', "#{search}%", "#{search.downcase}%"]
    end
    
    unless administrator?
      collection_options[:conditions] = ['games.pending=?', false]
    end

    collection_options
  end
  
  def clean_for_db
    params[:game][:gamefaqs_id] = nil if params[:game][:gamefaqs_id].blank?
    params[:game][:klov_id] = nil if params[:game][:klov_id].blank?
    
    if administrator?
      params[:game][:pending] = false
    else
      params[:game][:pending] = true
    end
    
    params[:game][:profile_id] = current_profile.id
  end
  
end