# Controls favoriting games and arcades.
class FavoritesController < ResourceController::Base
  belongs_to :game, :arcade
  before_filter :login_required
  
  # GET /users/1-adam/favorites
  # GET /arcades/1-rockys/favorites
  def create
    if parent_type == :game
      create_game
    elsif parent_type == :arcade
      create_arcade
    end
    
    redirect_to request.env["HTTP_REFERER"]
  end
  
  def destroy
    if parent_type == :game
      destroy_game
    elsif parent_type == :arcade
      destroy_arcade
    end    

    redirect_to request.env["HTTP_REFERER"]
  end
    
  private
  def create_arcade
    if current_user.has_favorite_arcade?(parent_object)
      flash[:error] = "You have already added <b>#{parent_object.name}</b> to your list of favorite arcades. <a href=\"#{user_arcades_path(current_user)}\">View your favorite arcades</a>."
    else
      current_user.arcades << parent_object
      flash[:notice] = "<span class=\"favorite arcade_add\">You added <b>#{parent_object.name}</b> to your list of favorite arcades! <a href=\"#{user_arcades_path(current_user)}\">View your favorite arcades</a>.</span>"
    end
  end
  
  def create_game
    if current_user.has_favorite_game?(parent_object)
      flash[:error] = "You have already added <b>#{parent_object.name}</b> to your list of favorite games. <a href=\"#{user_games_path(current_user)}\">View your favorite games</a>."
    else
      current_user.games << parent_object
      flash[:notice] = "<span class=\"favorite game_add\">You added <b>#{parent_object.name}</b> to your list of favorite games! <a href=\"#{user_games_path(current_user)}\">View your favorite games</a>.</span>"
    end
  end
  
  def destroy_arcade
    if favorite_arcade = Frequentship.find_by_arcade_id_and_user_id(parent_object.id,current_user.id)
      favorite_arcade.destroy
      flash[:notice] = "<span class=\"favorite arcade_delete\">You removed <b>#{parent_object.name}</b> from your list of favorite arcades. <a href=\"#{user_arcades_path(current_user)}\">View your favorite arcades</a>.</span>"
    else
      flash[:error] = "You have not added <b>#{parent_object.name}</b> to your list of favorite arcades, so how could you remove it? <a href=\"#{user_arcades_path(current_user)}\">View your favorite arcades</a>."
    end
  end
  
  def destroy_game
    if favorite_game = Favoriteship.find_by_game_id_and_user_id(parent_object.id,current_user.id)
      favorite_game.destroy
      flash[:notice] = "<span class=\"favorite game_delete\">You removed <b>#{parent_object.name}</b> from your list of favorite games. <a href=\"#{user_games_path(current_user)}\">View your favorite games</a>.</span>"
    else
      flash[:error] = "You have not added <b>#{parent_object.name}</b> to your list of favorite games, so how could you remove it? <a href=\"#{user_games_path(current_user)}\">View your favorite games</a>."
    end
  end
end
