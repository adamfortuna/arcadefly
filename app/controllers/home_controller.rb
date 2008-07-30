class HomeController < ApplicationController

  def index
    @profiles_count = Profile.count(:conditions => 'active = 1')
    @arcades_count = Arcade.count
    @arcade_games_count = Playable.count
    @games_count = Game.count
  end
  
  def about
  end
  
  def contact
  end
  
  def terms
  end
  
  def privacy
  end

  def site_map
  end
end