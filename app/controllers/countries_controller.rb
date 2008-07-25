class CountriesController < ApplicationController
  def index
    @countries = Country.find :all, :order => :name
  end
  
  # GET /arcades/countries/:id
  # :id will be the country id
  def show
    @arcades = sort_arcades_by_distance Arcade.search_by_country(params[:id], params[:page])
    @map = map_for_arcades(@arcades)
    @country = Country.find(params[:id])    
  end
end