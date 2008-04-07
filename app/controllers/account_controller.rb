class AccountController < ApplicationController
  before_filter :login_required, :except => :activate
  
  before_filter :not_logged_in_required, :only => :activate
 
  # After a user registers, they will receive an email with a link to this action to activate their account.
  # Upon clicking on it, their acocunt will be activated. 
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
  
  # Form for a logged in user to control their account information. This will include teh defaults - username, name, contact info, that kind of thing.
  # This will not include address though, since a user can have multiple addresses and that would be a bit much for this form.
  def index
    @user = current_user
    
    # Change this user's password
    if request.post?
      
      if @user.update_attributes(:login => params[:user][:login])
        flash[:notice] = "Your account was updated."
        redirect_back_or_default('/account')
      else
        flash[:error] = "Looks like there was a problem. Details below!"
      end
    end
  end

  # This is the form for managing a users addresses. For the moment this is limited to only one address.
  # Todo: enable multiple addressses for this feature
  def addresses
    @user = current_user
  end
  
  # This is where the user will control their privacy settings associated with their account.
  def privacy
    @user = current_user
  end
  
  # Form for a logged in user to change their password
  def password
    @user = current_user
    
    # Change this user's password
    if request.post?
      
      if @user.authenticated?(params[:old_password]) #& @user.update_attributes(:password => params[:user][:password],
                                                    #                            :password_confirmation => params[:user][:password_confirmation])
        flash[:notice] = "Your password was changed."
        redirect_back_or_default('/account')
      else
        flash[:error] = "Looks like the password you entered doesn't match. Or the new password didn't match the confirmation."
      end
    end
  end
  
  # Form for a logged in user to control their preferences within the site. Such as how wide a range to search for, communication preferences,
  # what their home address should show as in their profile and more.
  def preferences
    @user = current_user
  end
  
end