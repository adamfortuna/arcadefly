class JavascriptsController < ApplicationController
  caches_page :dynamic_regions, :dynamic_games

  def dynamic_regions
    @regions = Region.find(:all)
  end

  def dynamic_games
    @games = Game.find(:all)
  end

end
