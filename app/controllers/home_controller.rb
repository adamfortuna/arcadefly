class HomeController < ApplicationController
  caches_action :index,        :layout => false, :expires_in => 30.minutes
  caches_action :about,        :layout => false, :expires_in => 8.hours
  caches_action :contact,      :layout => false, :expires_in => 8.hours
  caches_action :terms,        :layout => false, :expires_in => 8.hours
  caches_action :privacy,      :layout => false, :expires_in => 8.hours
  caches_action :site_map,     :layout => false, :expires_in => 8.hours
  caches_action :four_oh_four, :layout => false, :expires_in => 8.hours

  def index
    @arcades = Arcade.recent
    @games = Game.recent
    @profiles = Profile.recent
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