# This is a very basic CRUD controller for managing games. Games can be accessed either by themselves
# or as a child of arcades or users.

class GamesController < ResourceController::Base
  belongs_to :arcade, :user
  
  # Override the helper method so that we can get a collection object for when Game isn't the parent. 
  def collection
    # GET /arcades/1/games
    if parent?
      @arcade = Arcade.find(params[:arcade_id], :include => 'games')
      @collection = @arcade.games
    # GET /games
    else
      @collection ||= Game.search(params[:search], params[:page])
    end
    @playables_count = (@collection.collect do |r| r.playables_count end).max.to_i * 1.1
    @collection
  end
  
  # Override the default object
  def object
    @object = Game.find(params[:id])
  end
  
  # This controls what views will be used depending on where the request is from.
  index.wants.html { 
    # GET /arcades/:arcade_id/games
    if parent_type == :arcade
      render :template => "arcades/games" 
    elsif parent_type == :user
      render :template => "users/games" 
    # GET /games
    else
      render :template => "games/index"
    end
  }
  
  def favorite
    @game = Game.find(params[:id])
    if !(current_user.games.collect do |a| a.id end).include?(@game.id)
      current_user.games.push(@game)
      flash[:notice] = "You added <b>#{@game.name}</b> to your list of favorite games!"
    else
      flash[:error] = "You have already added <b>#{@game.name}</b> to your list of favorite games."
    end
    redirect_to game_path(@game)
  end
  
end