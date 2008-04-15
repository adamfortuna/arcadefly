# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :beta_check

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'arcadefly_session_id'
  
  protected
  def beta_check
    authenticate_or_request_with_http_basic do |username, password|
      username == "arcadefly" && password == "test"
    end
  end

  class << self
    attr_reader :parents
    def parent_resources(*parents)
      @parents = parents
    end
  end

  def parent_id(parent)
    request.path_parameters["#{ parent }_id"]
  end

  def parent_type
    self.class.parents.detect { |parent| parent_id(parent) }
  end

  def parent_class
    parent_type && parent_type.to_s.classify.constantize
  end

  def parent_object
    parent_class && parent_class.find_by_id(parent_id(parent_type))
  end
  
end