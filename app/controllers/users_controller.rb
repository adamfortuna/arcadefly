class UsersController < ResourceController::Base
  belongs_to :game, :arcade
  
  before_filter :not_logged_in_required, :only => [:new, :create, :activate] 
  before_filter :login_required, :only => [:edit, :update, :welcome]
  before_filter :check_administrator, :only => [:destroy, :enable]
  



  def collection
    parent? ? parent_object.users.paginate(options) : User.paginate(options)    
  end

  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search] 
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] || User::PER_PAGE
    collection_options[:order] = params[:order] || 'users.name'
    collection_options[:conditions] = ['profiles.display_name like ? OR profiles.full_name like ?', "#{search}%", "#{search}%" ] unless search.blank?
    collection_options
  end

  index.wants.html { 
    # GET /arcades/:arcade_id/users
    if parent_type == :arcade
      render :template => "arcades/users" 
    # GET /games/:game_id/users
    elsif parent_type == :game
      render :template => "games/users"
    # GET /users
    else
      render :template => "users/index"
    end
  }
  




  def object
    User.find(param, :include => { :address => [:region, :country] })
  end

  def show
    @user =  User.find(params[:id], :include => [ { :address => [:region] }])

    if @user.has_address?
      @map = GMap.new("user_map")
	    @map.control_init(:map_type => false, :small_zoom => true)
	    @map.center_zoom_init([@user.address.public_lat, @user.address.public_lng], 11)
	    @map.overlay_init(GMarker.new([@user.address.public_lat,@user.address.public_lng], :title => @user.login))
    end
  end
    
  # render new.rhtml
  def new
    @user = User.new(params[:profile])
    @user.profile = Profile.new()
    @user.profile.address = current_address if addressed_in?
    
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
  
  def edit
    raise if current_user.id != params[:id].to_i && !administrator?
    @user = User.find(params[:id], :include => :address)
  rescue
    permission_denied
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
 
  def activate
    # Uncomment and change paths to have user logged in after activation - not recommended
    self.current_user = User.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated and you've been logged in! Try filling out your public profile so people know a little more about you!"
    redirect_to edit_profile_path(@current_profile)
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
 
  protected
  def object
    @object ||= end_of_association_chain.find_by_permalink(param)
  end

end