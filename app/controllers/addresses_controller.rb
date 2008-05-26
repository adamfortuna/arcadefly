class AddressesController < ResourceController::Base
  before_filter :not_logged_in_required, :only => :create
  belongs_to :user, :game, :session
  
  # GET /users/1/addresses/new
  # Todo: Add the ability for users to add multiple addresses
  def new
    @address = Address.new
  end

  # GET /users/1-adam/addresses/1/edit
  # Todo: Implement multiple addresses
  def edit
    @address = Address.find(params[:id])
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    raise if !params[:address]
    loc = Address.geocode(params[:address])
    raise if loc.lat.nil? || loc.lng.nil?
    
    # If this is the same address they're logged in with, don't do anything
    if addressed_in? && (current_address.lat == loc.lat) && (current_address.lng == loc.lng)
      # Maybe give an additional notice here eventually letting them know nothing happend?
      flash[:warning] = "It looks like this is the same location you have on file, so we decided not to change anything."
    else      
      region = Region.find_by_abbreviation(loc.state)
      country = Country.find_by_alpha_2_code(loc.country_code)
      debugger
      address = Address.new(:title => 'Quick Lookup',
                                            :addressable_type => 'Session', 
                                            :addressable_id => Session.find_by_session_id(session.session_id).id,
                                            :region => region,
                                            :country => country,
                                            :street => loc.street_address,
                                            :postal_code => loc.zip,
                                            :city => loc.city)
      debugger
      address.save
      self.current_address = address
    end
    flash[:notice] = "<form action=\"/signup\" method=\"post\" class=\"span-5 center right last inline\"><input type=\"submit\" class=\"big-button\" value=\"Register Now!\" /></form>"
    flash[:notice] += "Thanks for entering your location in <strong>#{current_address.short_line}</strong>. We'll use this address for the remainder of your visit here, but you can feel free to change it at any time from the <a href=\"/\">home page</a>. <strong>If you decide to <a href=\"/signup\">register</a> we'll save your address and you'll get access to even more features all for free!</strong>"
    if addressed_in?
      session[:address] = current_address.id
      redirect_to arcades_path
      return
    else
      flash[:error] = "We had trouble finding out just where your address is. Are you sure you typed it correctly?"
      redirect_to request.env["HTTP_REFERER"]
      return
    end
  rescue
    flash[:error] = "We had trouble finding out just where your address is. Are you sure you typed it correctly?"
    redirect_to request.env["HTTP_REFERER"]
  end

  # PUT users/1-adam/addresses/1
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        unless params[:user_id]
          format.html { redirect_to address_url(@address) }
        else
          format.html { redirect_to :controller => 'account'  }
        end
        
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end
end
