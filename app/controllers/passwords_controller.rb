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
      flash[:notice] = "Thanks! We sent an email to <b>#{params[:email]}</b> with instructions on how to reset the password for your account."
    redirect_to login_path
    else
      flash[:error] = "We couldn't find a user with that email address, <b>#{params[:email]}</b>. Do you want to try <a href=\"#{signup_url}?user[email]=#{params[:email]}\">signing up</a>?"
      redirect_to login_path
    end  
  end
  
  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a user in the database
  # Then if everything checks out, shows the password reset fields
  def edit
    if params[:id].nil?
      render :action => 'new'
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:error] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps the link was split over multiple lines and didn't come over correctly?)"    #redirect_back_or_default('/')
    redirect_to login_path
  end
    
  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update
    if params[:id].nil?
      flash[:error] = "No activation code was provided. Please make sure the entire link from your email was copied correctly."
      redirect_to login_path
      return
   elsif params[:password].blank? || params[:password_confirmation].blank?
      flash[:error] = "Both password fields cannot be blank. You do still want a new password right?"
      render :action => 'edit', :id => params[:id]
      return
   else
    
     @user = User.find_by_password_reset_code(params[:id])
     raise if @user.nil? # We should log an error if they entered an invalid reset code -- something might be going wrong
     return if @user unless params[:password]
     
     if params[:password] == params[:password_confirmation]
       @user.password_confirmation = params[:password_confirmation]
       @user.password = params[:password]
       @user.reset_password
       if @user.save?
         current_user = @user
         redirect_to user_account_path(current_user)
       else
         flash[:error] = "Your password was not reset. Make sure your password is between 4 and 50 characters long."
         render :action => 'edit', :id => params[:id]
         return
       end
     else
       flash[:error] = "The passwords you entered didn't match"
       render :action => 'edit', :id => params[:id]
       return
     end
   end
  rescue
    logger.error "Invalid Reset Code entered"
    flash[:error] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps the link was split over multiple lines and didn't come over correctly?)"
    redirect_to login_path
  end
    
end