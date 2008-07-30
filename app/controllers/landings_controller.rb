class LandingsController < ApplicationController


  # POST /landings
  def create
    session[:mobile_view] = params[:mobile_enabled] || false
    redirect_to root_url
  end

  # GET /landings/mobile
  def mobile
    render :action => "mobile", :layout => false
  end
end