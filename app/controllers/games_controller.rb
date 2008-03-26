# This is a very basic CRUD controller for managing games. Games can be accessed either by themselves
# or as a child of arcades or users.

class GamesController < ResourceController::Base
  belongs_to :arcade
  
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
  end
  
  # Override the default object
  def object
    @object = Game.find(params[:id])
  end
  
  # This controls what views will be used depending on where the request is from.
  index.wants.html { 
    # GET /arcades/:arcade_id/games
    if parent?
      render :template => "arcades/games" 
    # GET /games
    else
      render :template => "games/index"
    end
  }
    
end