class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'arcadefly_session_id_cookie'  

  # Sort this addressable by the distance from the current address
  def sort_by_distance(addressables)
    (addressables && addressables.length > 1 && addressed_in?) ? addressables.sort_by_distance_from(current_address) : addressables
  end
  
  def link_without_page(link)
    params = link.split('?')
    url = params.shift
    params.reject! { |n| n.match /page=/ }
    url = url + '?' + params.join('&') if params.length > 0
    url
  end
  
  private
  def current_session
    @user_session ||= UserSession.new(session, cookies)
  end
  helper_method :current_session
end