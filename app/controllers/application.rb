# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include AddressSystem  
  
  before_filter :beta_check

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'arcadefly_session_id'
  
  AMS_KEY = "096RRJ93PTDQPZZ44802"
  AMAZON_ASSOCIATES_ID = "adamfortuna-20"
  
  protected
  def beta_check
    authenticate_or_request_with_http_basic do |username, password|
      username == "arcadefly" && password == "test"
    end
  end  
end