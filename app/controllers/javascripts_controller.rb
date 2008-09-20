class JavascriptsController < ApplicationController
  caches_page :dynamic_regions

  def dynamic_regions
    @regions = Region.find(:all, :order => 'name')
  end

  def dynamic_games
    @games = Game.find(:all, :order => 'name', :limit => 100)
  end
end