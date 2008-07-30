class HomeController < ApplicationController

  before_filter :modile_landing, :only => [:index]

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

  def modile_landing
    debugger
    redirect_to mobile_landings_path if is_mobile_device? && session[:mobile_view].nil?
  end
end