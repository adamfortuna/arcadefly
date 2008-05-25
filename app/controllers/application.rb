class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'arcadefly_session_id'
  
  AMS_KEY = "096RRJ93PTDQPZZ44802"
  AMAZON_ASSOCIATES_ID = "adamfortuna-20"
end