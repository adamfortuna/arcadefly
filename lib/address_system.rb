module AddressSystem
  protected
  
  # Inclusion hook to make #current_address and #addressed_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :addressed_in?, :current_address
  end
  
  def addressed_in?
    current_address != :false
  end

  def current_address
    if logged_in? and current_profile.has_address?
      current_profile.address
    elsif @current_address
      @current_address
    elsif session[:address]
      @current_address = Address.find(session[:address], :conditions => 'addressable_type="Session"')
    else
      :false
    end
  end

  def current_address=(new_address)
    session[:address] = (new_address.nil? || new_address.is_a?(Symbol)) ? nil : new_address.id
    @current_address = new_address
  end
end