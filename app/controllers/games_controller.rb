class GamesController < ResourceController::Base
  belongs_to :arcade, :profile
  
  before_filter :check_administrator, :only => [:new, :create]
  
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
    render :text => @games.to_xml(:dasherize => false, :only => Game::PUBLIC_FIELDS)
  }
  
  show.wants.xml {
    render :text => @game.to_xml(:dasherize => false, :only => Game::PUBLIC_FIELDS)
  }
  
  def popular
    @games = Game.paginate(:all, :order => 'favoriteships_count desc, playables_count desc', :page => params[:page])
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
  
  
  private
  
  def object
    Game.find_by_permalink(params[:id])
  end
  
  def parent_object
    return Profile.find_by_permalink(params[:profile_id]) if parent_type == :profile
    return Arcade.find_by_permalink(params[:arcade_id]) if parent_type == :arcade
  end
  
  def collection
    debugger
    if parent_type == :arcade
      objects = parent_object.playables.paginate(options)
    elsif parent_type == :profile
      objects = parent_object.games.paginate(options)
    else
      objects = Game.paginate(options)
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
    collection_options[:include] = :game if parent_type == :arcade
    collection_options[:page] = params[:page] || 1
    #collection_options[:per_page] = params[:per_page] if params[:per_page]
    collection_options[:order] = params[:order] || 'games.name'
    if search == '#'
      collection_options[:conditions] = ['games.name regexp "^[0-9]+"']
    elsif !search.blank?
      collection_options[:conditions] = ['games.name like ?', "#{search}%" ]
    end
    collection_options
  end
end