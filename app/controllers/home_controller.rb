class HomeController < ApplicationController

  def index
    if !fragment_exist? :home
      @arcades = Arcade.recent
      @games = Game.recent
      @profiles = Profile.recent
    end
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
  
  def four_oh_four
  end
end