#require 'amazon/aws/search'

#include Amazon::AWS
#include Amazon::AWS::Search

class GamesController < ResourceController::Base
  belongs_to :arcade, :profile
  
  # Override the helper method so that we can get a collection object for when Game isn't the parent. 
  def collection
    # GET /arcades/1-disney/games
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id])
      @collection = @arcade.playables.paginate :page => params[:page], :include => :game, :order => 'games.name', :per_page => Game::PER_PAGE
    # GET /profiles/1-adam/games
    elsif parent_type == :profile
      @profile = Profile.find(params[:profile_id])
      @collection = @profile.games.paginate :page => params[:page], :order => 'name', :per_page => Game::PER_PAGE
    # GET /games
    else
      @collection ||= Game.search(params[:search], params[:page])
    end
    @max_count = Game.maximum(:playables_count) if @collection.size > 0
    #@playables_count = (@collection.collect do |r| r.playables_count end).max.to_i * 1.1
    @collection
  end
  
  
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
  
  def show
    @game = object
   
    @arcades_popularity =  Game.count(:conditions => ['playables_count > ?', @game.playables_count])+1
    @users_popularity =  Game.count(:conditions => ['favoriteships_count > ?', @game.favoriteships_count])+1
  
    
    # Get the Amazon items with this name
    #is = ItemSearch.new( 'VideoGames', { 'Keywords' => @game.name } )
    #rg = ResponseGroup.new( 'Small' )
    #req = Request.new(AMS_KEY, AMAZON_ASSOCIATES_ID)
    #req.locale = 'us'
    #resp = req.search( is, rg )

    #@items = resp.item_search_response[0].items[0].item
  #rescue
    #@items = []
  end
end