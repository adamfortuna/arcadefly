class AddressesController < ApplicationController
  # GET /addresses
  # GET /addresses.xml
  def index
    unless params[:user_id]
      @addresses = Address.find(:all)
    else
      @addresses = [current_user.address]
    end
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @addresses.to_xml }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    unless params[:user_id]
      @address = Address.find(params[:id])
    else
      @address = current_user.address
    end
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @address.to_xml }
    end
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
    unless params[:user_id]
      @address = Address.find(params[:id])
    else
      @address = current_user.address
    end
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to address_url(@address) }
        format.xml  { head :created, :location => address_url(@address) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
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

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_url }
      format.xml  { head :ok }
    end
  end
end
