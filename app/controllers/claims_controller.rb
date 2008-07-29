class ClaimsController < ApplicationController

  before_filter :login_required
  before_filter :parent_object
  
  # GET /arcades/:arcade_id/claims/new
  def new
  end 
  
  # POST /arcades/:arcade_id/claims
  def create
    @arcade = parent_object
    @claim = Claim.new(:profile => current_profile, :arcade => parent_object, :level => params[:claim][:level], :reason => params[:claim][:reason], :name => params[:claim][:name])
    
    if @claim.save
      flash[:notice] = "You successfully put in a claim for \"#{@arcade.name}\". We'll send you an email when your claim has been processed."
      redirect_to arcade_url(parent_object)
    else
      flash[:error] = "Looks like some of the form is incomplete. Please correct the problems below and try agains."
      render :action => 'new'
    end
  end
  
  def destroy
    claim = current_profile.claims.find_by_arcade_id(@arcade.id)
    
    if claim.destroy
      flash[:notice] = "Successfully removed your claim to \"#{@arcade.name}\". If you ever change your mind, feel free to re-claim it."
    else
      flash[:error] = "There was a problem removing your claim."
    end
    redirect_to arcade_url(parent_object)
  end
  
  private
  def parent_object
    @arcade = Arcade.find_by_permalink(params[:arcade_id])
  end
  
end