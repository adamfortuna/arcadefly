# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'application'
  #before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  # render new.rhtml
  def new
  end
 
  def create
    password_authentication(params[:email], params[:password])
  end
 
  def destroy
    self.current_user.forget_me if logged_in? && current_user.remember_token?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out. Come back again soon!"
    redirect_to login_path
  end
  
  protected
  
  def password_authentication(email, password)
    self.current_user = User.authenticate(email, password)
    if logged_in?
      successful_login
    else
      failed_login("Either your email and password was entered incorrectly, or you may not have activated your account. If you're having problems signing in, try retrieving your password.")
    end
  end
  
  
  private
  def failed_login(message)
    flash.now[:error] = message
    render :action => 'new'
  end
  
  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    
    flash[:notice] = "You're now logged in! Enjoy the map-py, arcadey goodness!"
    return_to = session[:return_to]

    if return_to.nil?
      redirect_to profile_path(current_profile)
    else
      redirect_to return_to
    end
  end
 
end

