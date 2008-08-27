# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
#  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  def index
    redirect_to root_url
  end

  def new
  end
 
  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      successful_login
    else
      flash[:error] = "Either your email and password was entered incorrectly, or you may not have activated your account. If you're having problems signing in, try retrieving your password."
      redirect_to signin_path
    end
  end
 
  def destroy
    self.current_user.forget_me if logged_in? && current_user.remember_token?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = logged_in? ? "You have been logged out." : "Your address has been cleared out."
    flash[:notice] += "<br/><br/>ArcadeFly is possible because of gamers like you -- please come back again and see us!"
    redirect_to root_path
  end
  
  private
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

