class UsersController < ResourceController::Base
  belongs_to :game, :arcade
  
  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :login_required, :only => [:edit, :update]
  before_filter :check_administrator_role, :only => [:destroy, :enable]
  
  def collection
    # GET /arcades/1-disney/users
    if parent_type == :arcade
      @arcade = Arcade.find(params[:arcade_id], :include => 'users')
      @collection = @arcade.users
    #GET /games/1-ABC/users
    elsif parent_type == :game
      @game = Game.find(params[:game_id], :include => 'users')
      @collection = @game.users
    # GET /users
    else
      @collection = User.find(:all)
    end
    @collection
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
    @user =  User.find(params[:id], :include => 'address')

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
    flash[:notice] = "Thanks for signing up, <b>#{@user.login}</b>! Please check your email and click on the link we sent you to activate your account and log in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account. Please correct any errors below before continuing."
    render :action => 'new'
  end
  
  def edit
    @user = User.find(params[:id])
    raise if current_user != @user  && !check_administrator_role
  end
  
  def update
    raise if current_user.login != params[:id] && !check_administrator_role
        
    @user = User.find_by_login(params[:id])
    if params[:change_address]
      @user.address = Address.new(params[:address])
      saved = @user.address.save
    elsif params[:change_password]
      if !@user.authenticated?(params[:old_password])
        @user.errors.add('current_password', 'is not correct. Please re-enter it.')
      else
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        saved = @user.save
      end
    elsif params[:change_username]
      @user.login = params[:user][:login]
      saved = @user.save
    end
    
    if saved
      flash[:notice] = (@user == current_user) ? "Your user account has been updated!" : "User updated."
      redirect_to :action => 'show', :id => @user
    else
      flash[:error] = 'There was a problem updating your account. Check out the error details below.'
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
 
 
  protected
  def object
    @object ||= end_of_association_chain.find_by_permalink(param)
  end

end