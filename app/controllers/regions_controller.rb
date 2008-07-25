class RegionsController < ApplicationController
  def index
    @regions = Region.find :all, :order => :name
  end
  
  # GET /arcades/regions/:id
  # :id will be the region id
  def show
    @arcades = sort_arcades_by_distance Arcade.search_by_region(params[:id], params[:page])
    @map = map_for_arcades(@arcades)
    @region = Region.find(params[:id].to_s)
  end
end