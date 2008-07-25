class LocationsController < ApplicationController
  
  # Get a list of all countries and regions that have arcades
  def index
    @countries = Country.find(:all, :include => :addresses, :conditions => 'addresses.addressable_type="Arcade"', :order => 'countries.name')
    @regions = Region.find(:all, :include => :addresses, :conditions => 'addresses.addressable_type="Arcade"', :order => 'regions.name')
  end
end