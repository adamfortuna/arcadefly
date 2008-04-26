class HomeController < ApplicationController

  def index
    @games = Game.find(:all, :order => 'favoriteships_count desc', :limit => 30)
  end
  
  def about
  end
  
  def contact
  end
  
  def terms
  end
  
  def privacy
  end

end
