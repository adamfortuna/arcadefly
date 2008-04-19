class PopularController < ApplicationController

  def index
  end
  
  # Todo: Paginate
  def arcades
    @arcades = Arcade.find(:all, :order => 'frequentships_count desc, playables_count desc', :limit => 20, :include => [ { :address => :region } ] )
    @max_count = Arcade.maximum(:frequentships_count)
  end

  # Todo: Paginate
  def games
    @games = Game.find(:all, :order => 'favoriteships_count desc, playables_count desc', :limit => 20)
    @max_count = Game.maximum(:favoriteships_count)
  end

end
