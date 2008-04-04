class UsersController < ApplicationController
  layout 'application'
  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :login_required, :only => [:show, :edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  def index
    @users = User.find(:all)
  end
  
  def show
    @user =  User.find_by_login(params[:id], :include => 'address')

    if @user.has_address?
      @map = GMap.new("user_map")
	    @map.control_init(:map_type => false, :small_zoom => true)
	    @map.center_zoom_init([@user.address.public_lat, @user.address.public_lng], 11)
	    @map.overlay_init(GMarker.new([@user.address.public_lat,@user.address.public_lng], :title => @user.login))
    end
	                    
  end
    
  # render new.rhtml
  def new
    @user = User.new(params[:user])
    @add_address = params[:add_address] || true
  end
 
  def create
    @add_address = params[:add_address]
    cookies.delete :auth_token
    @user = User.new(params[:user])
    if params[:add_address]
      @user.address = Address.new(params[:address])
    end
    @user.save!
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    flash[:notice] = "Thanks for signing up, <b>#{@user.login}</b>! Please check your email and click on the link we sent you to activate your account and logging in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account. Please correct any errors below before continuing."
    render :action => 'new'
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
 
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
      redirect_to :action => 'index'
  end
 
end