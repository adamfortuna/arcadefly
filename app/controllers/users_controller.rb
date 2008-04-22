class UsersController < ResourceController::Base
  belongs_to :game, :arcade
  
  before_filter :not_logged_in_required, :only => [:new, :create, :activate] 
  before_filter :login_required, :only => [:edit, :update]
  before_filter :check_administrator_role, :only => [:destroy, :enable]
  
  def collection
    # GET /arcades/1-disney/users
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id], :include => 'users')
      @collection = @arcade.users.paginate :page => params[:page], :order => 'name', :per_page => User::PER_PAGE
    #GET /games/1-ABC/users
    elsif parent_type == :game
      @game = Game.find(params[:game_id], :include => 'users')
      @collection = @game.users.paginate :page => params[:page], :order => 'name', :per_page => User::PER_PAGE
    # GET /users
    else
      @collection = User.find(:all, :include => { :address => [:region, :country] })
    end
    @collection
  end

  def object
    User.find(param, :include => { :address => [:region, :country] })
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
    @user = User.new(params[:user])
    @user.address = current_address if addressed_in?
    @add_address = params[:add_address] || true
  end
 
  def create
    @add_address = params[:add_address]
    cookies.delete :auth_token
    @user = User.new(params[:user])
    if params[:add_address]
      @user.address = Address.new(params[:address])
      @user.address.title = "My Home"
    end
    @user.save!
    
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    flash[:notice] = "Thanks for signing up, <b>#{@user.login}</b>! Please check your email and click on the link we sent you to activate your account and log in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account. Please correct any errors below before continuing."
    render :action => 'new'
  end
  
  def edit
    @user = User.find(params[:id], :include => :address)
    raise if current_user != @user  && !check_administrator_role
  end
  
  def update
    raise if current_user.id != params[:id].to_i
        
    @user = User.find(params[:id])
    if params[:change_address]
      @user.address = Address.new(params[:address])
      saved = @user.address.save
    elsif params[:change_password]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if !@user.authenticated?(params[:old_password])
        @user.valid?
        @user.errors.add('current_password', 'is not correct. Please re-enter it.')
      else
        saved = @user.save
      end
    elsif params[:change_username]
      @user.login = params[:user][:login]
      saved = @user.save
    elsif params[:update_profile]
      @user.about = params[:user][:about]
      saved = @user.save
    end

    if saved
      flash[:notice] = (@user == current_user) ? "Your user account has been updated!" : "User updated."
      redirect_to :action => 'show', :id => @user
      return
    else
      flash[:error] = 'There was a problem updating your account. Check out the error details below.'
      render :action => 'edit'
      return
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
 
  def activate
    # Uncomment and change paths to have user logged in after activation - not recommended
    self.current_user = User.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated and you've been logged in!"
    redirect_to welcome_url
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