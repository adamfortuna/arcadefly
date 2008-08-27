class AddressesController < ResourceController::Base
  before_filter :not_logged_in_required, :only => :create
  belongs_to :user, :game, :session
  
  def index
    redirect_to root_url
  end

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
    current_session.address = Address.geocode(params[:address])
    current_session.arcade_range = 0
    next_page = ["http://localhost:3000/", "http://www.arcadefly.com/"].include?(request.referrer) ? arcades_path : request.referrer
    if current_session.address.lat.nil? || current_session.address.lng.nil?
      flash[:error] = "We had trouble finding out just where your address is. Are you sure you typed it correctly?"
      redirect_to next_page
    else
      flash[:notice] = "<form action=\"/signup\" method=\"post\" class=\"right\"><input type=\"submit\" class=\"big-button\" value=\"Register Now!\" /></form>"
      flash[:notice] += "Thanks for entering your location in <strong>#{current_session.address.short_line}</strong>. We'll use this address for the remainder of your visit here, or until you change it. <strong>If you decide to <a href=\"/signup\">register</a> we'll save your address and you'll get access to even more features all for free!</strong>"
      redirect_to next_page
    end
  end
end