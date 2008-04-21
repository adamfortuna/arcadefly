require 'amazon/aws/search'

include Amazon::AWS
include Amazon::AWS::Search

class GamesController < ResourceController::Base
  belongs_to :arcade, :user
  
  # Override the helper method so that we can get a collection object for when Game isn't the parent. 
  def collection
    # GET /arcades/1-disney/games
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id], :include => 'games')
      @collection = @arcade.games.paginate :page => params[:page], :order => 'name', :per_page => Game::PER_PAGE
    # GET /users/1-adam/games
    elsif parent_type == :user
      @user = User.find(params[:user_id], :include => 'games')
      @collection = @user.games.paginate :page => params[:page], :order => 'name', :per_page => Game::PER_PAGE
    # GET /games
    else
      @collection ||= Game.search(params[:search], params[:page])
    end
    @playables_count = Game.maximum(:playables_count) if @collection.size > 0
    #@playables_count = (@collection.collect do |r| r.playables_count end).max.to_i * 1.1
    @collection
  end
  
  
  # This controls what views will be used depending on where the request is from.
  index.wants.html {
    # GET /arcades/:arcade_id/games
    if parent_type == :arcade
      render :template => "arcades/games" 
    # GET /users/:user_id/games
    elsif parent_type == :user
      render :template => "users/games" 
    # GET /games
    else
      render :template => "games/index"
    end
  }
  
  def show
    @game = object
    
    # Get the Amazon items with this name
    is = ItemSearch.new( 'VideoGames', { 'Keywords' => @game.name } )
    rg = ResponseGroup.new( 'Small' )
    req = Request.new(AMS_KEY, AMAZON_ASSOCIATES_ID)
    req.locale = 'us'
    resp = req.search( is, rg )

    @items = resp.item_search_response[0].items[0].item
  rescue
    @items = []
  end
  
  

  def favorite
    raise if !(game = Game.find(params[:id]))
    
    create_favorite(game) if request.post?
    destroy_favorite(game) if request.delete?
    
    redirect_to request.env["HTTP_REFERER"]
  #rescue
  #  flash[:error] = "Doesn't look like that was a valid game. Wannt to try again?"
  #  redirect_back_or_default('/games')
  end
  
  private
  def create_favorite(game)
    if current_user.has_favorite_game?(game)
      flash[:error] = "You have already added <b>#{game.name}</b> to your list of favorite games."
    else
      current_user.games.push(game)
      flash[:notice] = "<span class=\"favorite_add\">You added <b>#{game.name}</b> to your list of favorite games!</span>"
    end
  end
  
  def destroy_favorite(game)
    if favorite_game = Favoriteship.find_by_game_id_and_user_id(game.id,current_user.id)
      favorite_game.destroy
      flash[:notice] = "<span class=\"favorite_delete\">You removed <b>#{game.name}</b> from your list of favorite games.</span>"
    else
      flash[:error] = "You have not added <b>#{game.name}</b> to your list of favorite games, so how could you remove it?"
    end
  end
  
  
end