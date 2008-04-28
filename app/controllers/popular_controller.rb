class PopularController < ApplicationController

  def index
    @arcades = Arcade.find(:all, :limit => 10, :group => 'arcades.name', :include => :frequentships, :conditions => 'frequentships.created_at > 04-01-2008')
    @games = Game.find(:all, :limit => 10, :group => 'games.name', :include => :favoriteships, :conditions => 'favoriteships.created_at > 04-01-2008')
  end
  
  # Todo: Paginate
  def arcades
    @arcades = Arcade.paginate(:all, :order => 'frequentships_count desc, playables_count desc', :include => [ { :address => :region } ], :page => params[:page], :per_page => Arcade::PER_PAGE )
    @max_count = Arcade.maximum(:frequentships_count)
  end

  # Todo: Paginate
  def games
    @games = Game.paginate(:all, :order => 'favoriteships_count desc, playables_count desc', :page => params[:page], :per_page => Game::PER_PAGE)
    @max_count = Game.maximum(:favoriteships_count)
  end

end
