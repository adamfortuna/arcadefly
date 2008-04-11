# This is a very basic CRUD controller for managing games. Games can be accessed either by themselves
# or as a child of arcades or users.

class GamesController < ResourceController::Base
  belongs_to :arcade, :user
  
  # Override the helper method so that we can get a collection object for when Game isn't the parent. 
  def collection
    # GET /arcades/1-disney/games
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id], :include => 'games')
      @collection = @arcade.games
    # GET /users/1-adam/games
    elsif parent_type == :user
      @user = User.find(params[:user_id], :include => 'games')
      @collection = @user.games
    # GET /games
    else
      @collection ||= Game.search(params[:search], params[:page])
    end
    @playables_count = Game.maximum(:playables_count) * 1.1
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
  
  def favorite
    @game = Game.find(params[:id])
    
    # POST /games/1-game-name/favorite
    if request.post?
      if !(current_user.games.collect do |a| a.id end).include?(@game.id)
        current_user.games.push(@game)
        flash[:notice] = "You added <b>#{@game.name}</b> to your list of favorite games!"
      else
        flash[:error] = "You have already added <b>#{@game.name}</b> to your list of favorite games."
      end
    elsif request.delete?
      if favorite_game = Favoriteship.find_by_game_id_and_user_id(@game.id,current_user.id)
        current_user.favoriteships.delete(favorite_game)
        flash[:notice] = "You removed <b>#{@game.name}</b> from your list of favorite games."
      else
        flash[:error] = "You have not added <b>#{@game.name}</b> to your list of favorite games, so how could you remove it?"
      end
    end
    redirect_to game_path(@game)
  end
  
  
end