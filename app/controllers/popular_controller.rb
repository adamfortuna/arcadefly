class PopularController < ApplicationController

  def index
    @arcades = Arcade.find(:all, :limit => 10, :group => 'arcades.name', :include => :frequentships, :conditions => 'frequentships.created_at > 04-01-2008')
    @games = Game.find(:all, :limit => 10, :group => 'games.name', :include => :favoriteships, :conditions => 'favoriteships.created_at > 04-01-2008')
  end
end