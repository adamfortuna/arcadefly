class UserSession
  
  def initialize(session, cookies)
    @session = session
    @cookies = cookies
    @current_profile = build_profile
    @current_address = build_address
    if !addressed_in? && logged_in? && profile.has_address?
      @current_address = profile.address
      
      @session[:address_street] = address.street
      @session[:address_city] = address.city
      @session[:address_region] = address.region.abbreviation if address.region?
      @session[:address_country] = address.country.alpha_3_code
      @session[:address_zip] = address.postal_code
      @session[:address_lat] = address.lat
      @session[:address_lng] = address.lng
    end
    @current_arcade_range = build_range(session[:arcade_range])
    @current_profile_range = build_range(session[:profile_range])
  end
  
  def logged_in?
    !@current_profile.nil?
  end
  
  def user
    profile.user
  end
  
  def user=(new_user)
    @session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_profile = new_user.profile if !new_user.nil?
    @current_user = new_user if !new_user.nil?
  end
  
  def profile
    @current_profile
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
      :region => Region.new({:name => address.state, :abbreviation => @session[:address_state]}),
      :country => Country.new({:name => address.country_code, :alpha_2_code => @session[:address_country], :alpha_3_code => @session[:address_country]}),
      :postal_code => address.zip,
      :lat => address.lat,
      :lng => address.lng
    })
    @current_address
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
  def build_address
    return Address.new unless @session[:address_lat] && @session[:address_lng]
    return Address.new({
      :street => @session[:address_street],
      :city =>  @session[:address_city],
      :region => Region.new({:name => @session[:address_region], :abbreviation => @session[:address_region]}),
      :country =>  Country.new({:name => @session[:address_country], :alpha_2_code => @session[:address_country], :alpha_3_code => @session[:address_country]}),
      :postal_code => @session[:address_zip],
      :lat => @session[:address_lat],
      :lng =>  @session[:address_lng]      
    })
  end
  
  def build_profile
    (profile_from_session  || profile_from_cookie || nil)
  end
  def profile_from_session
    Profile.find_by_user_id(@session[:user]) if @session[:user]
  end
  def profile_from_cookie
    user = @cookies[:auth_token] && User.find_by_remember_token(@cookies[:auth_token])
    if user && user.remember_token?
      user.remember_me
      @cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      @session[:user] = user.id
      @current_user = user
      return @current_user.profile
    end
    return false
  end

  def build_range(range)
    return 0 if range.nil? || range.to_i == 0 || range.to_i > 5000
    return range.to_i
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
