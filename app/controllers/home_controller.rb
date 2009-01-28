class HomeController < ApplicationController

  def index
    @arcades = Arcade.find(:all, :order => 'created_at desc', :include => [ { :address => [:country, :region] }], :limit => 10)
    @games = Game.find(:all, :order => 'favoriteships_count desc, playables_count desc', :limit => 10)
    @profiles = Profile.find(:all, :order => 'created_at desc', :conditions => ['active=?', true], :limit => 10)
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