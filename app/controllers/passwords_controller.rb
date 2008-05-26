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
      flash[:notice] = "We sent an email to <b>#{@user.profile.email}</b> with instructions on how to change your password. Please give it a few minutes to arrive, then you should be able to sign in."
    elsif @profile = Profile.find_by_email(params[:email], :include => :user)      
      @profile.user.requested_signup_notification
      @profile.user.save
      flash[:error] = "It looks like you never activated your account. We sent an email to <b>#{@profile.email}</b> with instructions on how to activate and change the password for your account."
    else
      flash[:error] = "We couldn't find a user with the email address <b>#{params[:email]}</b>. Do you want to try <a href=\"#{signup_url}?profile[email]=#{params[:email]}\">signing up</a>?"
    end  
    redirect_to signin_path
  end
  
  # GET /reset_password/:id
  def edit
    if request.put?
      update
    else
      raise if params[:id].nil? || !(@user = User.find_by_password_reset_code(params[:id]))
      flash[:notice] = "Welcome back <strong>#{@user.profile.email}</strong>! Please choose a new password."
    end
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:error] = "Sorry, that is an invalid password reset code. Please check your code and try again. Perhaps the link was split over multiple lines and didn't come over correctly?"
    redirect_to login_path
  end
    
  # PUT /passwords/:id
  def update
    raise if !(@user = User.find_by_password_reset_code(params[:id]))
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.password = params[:user][:password]

    if @user.valid?
      @user.reset_password
      @user.save!
      self.current_user = @user
      flash[:notice] = "Your password has been changed and you've been logged in. We also emailed you to let you know something happend."
      redirect_to profile_path(@user.profile)
      return
    else
      flash[:error] = "There was a problem changing your password. Please correct the errors below and continue."
    end
  rescue
    @user.errors.add(:password, "must match and be at least 4 characters.")
    flash[:error] = "There was a problem changing your password. Please correct the errors below and continue."
  end
    
end