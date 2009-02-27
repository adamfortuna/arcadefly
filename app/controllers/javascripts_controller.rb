class JavascriptsController < ApplicationController
  caches_page :dynamic_regions
  layout nil

  def dynamic_regions
    @regions = Region.find(:all, :order => 'name')
  end
end