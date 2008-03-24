# This is a RESTful controller for managing user accounts. Since an Account is an abstract idea, not an actual table in the
# database there is no associated model. An Account is considered the information associated with a User with which they can
# access the site. The methods within control whether or not the user can access their "Account". There isn't a create for
# this though, since creating a User creates an account.

class AccountsController < ApplicationController
  layout 'application'
  before_filter :not_logged_in_required, :only => :show
 
  # After a user registers, they will receive an email with a link to this action to activate their account.
  # Upon clicking on it, their acocunt will be activated. 
  def show
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
 
end