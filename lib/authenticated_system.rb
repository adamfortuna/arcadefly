module AuthenticatedSystem
  protected
    # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?, :current_profile, :administrator?, :addressed_in?, :current_address, :current_range
    end





    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      current_profile != :false
    end
    
    # Returns true or false if the user has an address
    def addressed_in?
      current_address != :false
    end
    
    # Accesses the current user from the session.  Set it to :false if login fails
    # so that future calls do not hit the database.
    def current_profile
      @current_profile ||= (profile_from_session  || profile_from_cookie || :false)
    end
    
    # Accesses the current user from the session.  Set it to :false if login fails
    # so that future calls do not hit the database.
    def current_user
      @current_user ||= (login_from_session  || login_from_cookie || :false)
    end
    
    # Accessed the current profile from the profile or session
    def current_address 
      @current_address ||= (address_from_profile || address_from_session || :false)
    end
    
    # Store the given user in the session.
    def current_user=(new_user)
      session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
      @current_profile = new_user.profile if !new_user.nil?
      @current_user = new_user
    end
    
    # Store the given address in the session
    def current_address=(new_address)
      session[:address] = (new_address.nil? || new_address.is_a?(Symbol)) ? nil : new_address.id
      @current_address = new_address
    end
    
    def current_range=(new_range)
      session[:range] = new_range
    end

    def current_range
      session[:range] ? session[:range] : 100
    end
    
    
    
    
    
    
    

    # Before filters for controllers
    def administrator?
      logged_in? && current_profile.administrator?
    end
    
    def login_required
      logged_in? || addressed_in? || permission_denied
    end

    def not_logged_in_required
      !logged_in? || permission_denied
    end
    
    def check_administrator
      permission_denied if !logged_in? || !current_profile.administrator?
    end
    
    
    
  

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |accepts|
        accepts.html do
          store_location
          redirect_to '/login'
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Could't authenticate you", :status => '401 Unauthorized'
        end
      end
      false
    end  
    
    def permission_denied
      respond_to do |format|
        format.html do
          store_location
          flash[:error] = "You don't have permission to complete that action."
          domain = "http://localhost:3000" #modify for your application settings
          http_referer = request.env["HTTP_REFERER"]
          request_path = request.env["REQUEST_PATH"]
          full_path = domain + request_path
          if http_referer.nil? || full_path.nil?
            redirect_to root_path
          else
            #Another area that needs to be modified for your app
            #The [0..20] represents the 21 characters in http://localhost:3000
            #You have to set that to the number of characters in your domain name
            if (http_referer[0..20] == domain) && (http_referer != full_path)
              redirect_to http_referer
            else
              redirect_to root_path
            end
          end
        end
        format.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "You don't have permission to complete this action.", :status => '401 Unauthorized'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end






    

    # Called from #current_profile.  First attempt to login by the user id stored in the session.
    def profile_from_session
      Profile.find_by_user_id(session[:user]) if session[:user]
    end

    # Called from #current_profile.  Finaly, attempt to login by an expiring token in the cookie.
    def profile_from_cookie      
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end

    # Called from #current_address. Will get the address form the profile if the user is logged in and has an address
    def address_from_profile
      current_profile.address if (logged_in? && current_profile.has_address?)
    end

    # Called from #current_address. Will get an address from the users session if they have one.
    def address_from_session
      Address.find(session[:address], :conditions => 'addressable_type="Session"') if session[:address]
    end







    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      self.current_user = User.find_by_id(session[:user]) if session[:user]
    end

    # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
    def login_from_cookie      
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end





  private
    @@http_auth_headers = %w(Authorization HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION REDIRECT_X_HTTP_AUTHORIZATION)

    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
    end
end
