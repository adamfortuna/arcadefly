class AddressesController < ResourceController::Base
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
    
    region = Region.find_by_abbreviation(loc.state)
    country = Country.find_by_alpha_2_code(loc.country_code)
    
    current_address = Address.create(:addressable_type => 'Session', 
                                     :region => region,
                                     :country => country,
                                     :street => loc.street_address,
                                     :postal_code => loc.zip,
                                     :city => loc.city)
    if current_address.valid?
      session[:address] = current_address.id
      redirect_to arcades_distance_path
    else
      flash[:error] = "We had trouble finding out just where your address is. Are you sure you typed it correctly?"
      redirect_to request.env["HTTP_REFERER"]
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
