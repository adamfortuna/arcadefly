class UserSession
  
  def initialize(session)
    @session = session
    @current_address = build_address(session)
    @current_arcade_range = build_range(session[:arcade_range])
    @current_profile_range = build_range(session[:profile_range])
  end
  
  def addressed_in?
    @current_address.lat? && @current_address.lng?
  end

  def address=(address)
    if address.success
      @session[:address_street] = address.street_address
      @session[:address_city] = address.city
      @session[:address_region] = address.state
      @session[:address_country] = address.country_code
      @session[:address_zip] = address.zip
      @session[:address_lat] = address.lat
      @session[:address_lng] = address.lng
    else
      @session[:address_street] = nil
      @session[:address_city] = nil
      @session[:address_region] = nil
      @session[:address_country] = nil
      @session[:address_zip] = nil
      @session[:address_lat] = nil
      @session[:address_lng] = nil
    end
    @current_address = Address.new({
      :street => address.street_address,
      :city =>  address.city,
      :region_name => address.state,
      :country_name => address.country_code,
      :postal_code => address.zip,
      :lat => address.lat,
      :lng => address.lng
    })
  end
  
  def address
    @current_address
  end
  
  def arcade_range=(range)
    @session[:arcade_range] = build_range(range)
    @current_arcade_range = build_range(range)
  end
  def arcade_range
    @current_arcade_range
  end

  def profile_range=(range)
    @session[:profile_range] = build_range(range)
    @current_profile_range = build_range(range)
  end
  def profile_range
    @current_profile_range
  end


  private
  def build_address(session)
    return Address.new({
      :street => session[:address_street],
      :city =>  session[:address_city],
      :region_name => session[:address_state],
      :country_name =>  session[:address_country],
      :postal_code => session[:address_zip],
      :lat => session[:address_lat],
      :lng =>  session[:address_lng]      
    })
  end
  
  def build_range(range)
    return 100000 if range.nil?
    range.to_i == 0 ? 100000 : range.to_i
  end
end



# # Called from #current_address. Will get the address form the profile if the user is logged in and has an address
# def address_from_profile
#   current_profile.address if (logged_in? && current_profile.has_address?)
# end
# 
# # Called from #current_address. Will get an address from the users session if they have one.
# def address_from_session
#   Address.find(session[:address], :conditions => 'addressable_type="Session"') if session[:address]
# end
