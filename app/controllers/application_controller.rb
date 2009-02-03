class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  filter_parameter_logging ["password", "password_confirmation", "verify_password"]

  # Sort this addressable by the distance from the current address
  def sort_by_distance(addressables)
    (addressables && addressables.length > 1 && current_session.addressed_in?) ? addressables.sort_by_distance_from(current_session.address) : addressables
  end
  
  def link_without_page(link)
    params = link.split('?')
    url = params.shift
    params.reject! { |n| n.match /page=/ }
    url = url + '?' + params.join('&') if params.length > 0
    url
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    redirect_to four_oh_four_url
  end
  
  private
  def current_session
    @user_session ||= UserSession.new(session, cookies)
  end
  helper_method :current_session
  
  def redirect_to_root
    redirect_to root_url
  end
end