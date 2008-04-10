class PasswordsController < ApplicationController
  layout 'application'
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  # Enter email address to recover password 
  def new
  end
 
  # Forgot password action
  def create    
    return unless request.post?
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save      
      flash[:notice] = "We sent an email to <b>#{@user.email}</b> with instructions on how to change the password for your account."
    elsif @user = User.find_by_email(params[:email])
      @user.requested_signup_notification
      @user.save
      flash[:error] = "It looks like you never activated your accounted. We sent an email to <b>#{@user.email}</b> with instructions on how to activate and change the password for your account."
    else
      flash[:error] = "We couldn't find a user with the email address <b>#{params[:email]}</b>. Do you want to try <a href=\"#{signup_url}?user[email]=#{params[:email]}\">signing up</a>?"
    end  
    redirect_to login_path
  end
  
  # GET /reset_password/:id
  def edit
    if request.put?
      update
    else
      raise if params[:id].nil? || !(@user = User.find_by_password_reset_code(params[:id]))
    end
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:error] = "Sorry, that is an invalid password reset code. Please check your code and try again. Perhaps the link was split over multiple lines and didn't come over correctly?"
    redirect_to login_path
  end
    
  # PUT /passwords/:id
  def update
    raise if !(@user = User.find_by_password_reset_code(params[:id]))
    @user.password_confirmation = params[:password_confirmation]
    @user.password = params[:password]

    if @user.valid?
      @user.reset_password
      @user.save!
      self.current_user = @user
      flash[:notice] = "Your password has been changed and you've been logged in. We also emailed you to let you know something happend."
      redirect_to root_url
      return
    else
      flash[:error] = "There was a problem changing your password. Please correct the errors below and continue."
    end
  rescue
    logger.error "Invalid Reset Code entered"
    flash[:error] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps the link was split over multiple lines and didn't come over correctly?)"
    redirect_to login_path
  end
    
end