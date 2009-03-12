class UsersController < ApplicationController
  before_filter :not_logged_in_required, :only => [:new, :create, :activate] 
  before_filter :login_required, :only => [:edit, :update, :welcome]
  before_filter :check_administrator, :only => [:destroy, :enable]
  
  def index
    redirect_to profiles_url
  end  
  
  def show
    redirect_to params[:id] ? profile_url(params[:id]) : profiles_url
  end
  
  # render new.rhtml
  def new
    @user = User.new(params[:profile])
    @user.profile = Profile.new()
    if current_session.addressed_in?
      @user.profile.address = current_session.address 
      @user.profile.address.region = Region.find_by_abbreviation(current_session.address.region.abbreviation)
      @user.profile.address.region_id = @user.profile.address.region.id
    end
    @add_address = params[:add_address] || true
  end
 
  def create
    @add_address = params[:add_address]
    cookies.delete :auth_token
    @user = User.new
    @user.profile = Profile.new
    
    @user.email = params[:user][:email]
    @user.email_confirmation = params[:user][:email_confirmation]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.profile.display_name = params[:profile][:display_name]
    
    if params[:add_address]
      @user.profile.address = Address.new(params[:address])
      @user.profile.address.title = "My Home"
    end

    raise if !@user.valid? || !@user.profile.valid?
    raise if params[:add_address] && !@user.profile.address.valid? 

    @user.save!
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    flash[:notice] = "Thanks for signing up, <strong>#{@user.profile.display_name}</strong>! Please check your email and <strong>click on the link we sent you</strong> to activate your account and log in."
    redirect_to signin_path
  rescue
    flash[:error] = "There was a problem creating your account. Please correct any errors below before continuing."
    render :action => 'new'
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
  
  def activate
    # Uncomment and change paths to have user logged in after activation - not recommended
    current_session.user = User.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated and you've been logged in! Try filling out your public profile so people know a little more about you!"
    redirect_to edit_profile_path(current_session.profile)
  rescue User::ArgumentError
    flash[:error] = 'Activation code invalid or not found. Please try creating a new account.'
    redirect_to '/signup'
  rescue User::ActivationCodeNotFound
    flash[:error] = 'That doesn\'t seem to be a valid activation code. Please try creating a new account.'
    redirect_to '/signup'
  rescue User::AlreadyActivated
    flash[:warning] = 'Your account has already been activated. You can log in below.'
    redirect_to '/login'
  end
 
end