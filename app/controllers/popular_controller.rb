class PopularController < ApplicationController

  def index
  end
  
  def arcades
    @arcades = Arcade.find(:all, :order => 'frequentships_count desc, playables_count desc', :limit => 20, :include => [ { :address => :region } ] )
  end

  def games
    @games = Game.find(:all, :order => 'favoriteships_count desc, playables_count desc', :limit => 20)
    @playables_count = Game.maximum(:playables_count) * 1.1
  end

end
