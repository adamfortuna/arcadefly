require File.dirname(__FILE__) + '/../spec_helper'

module AddressSpecHelper
  def valid_address_attributes
    {
      :title => "Example Address",
      :street => '1130 Summer Lakes Drive',
      :city => "Orlando",
      :region => Region.find_by_name("Florida"),
      :postal_code => "32835"
    }
  end
  
  def mock_geocode(address, ll)
    GeoKit::Geocoders::GoogleGeocoder.
      should_receive(:geocode).
      with(address).
      and_return(ll)
  end
end

describe Address do
  include AddressSpecHelper
  
  before(:each) do
    @address = Address.new
  end

  it "should have errors" do
    @address.should have(1).error_on(:title)
    @address.should have(1).error_on(:city)
    @address.should have(1).error_on(:postal_code)
  end

  it "should be valid when complete" do
    @address.attributes = valid_address_attributes
    @address.should be_valid
  end
  
  it "should populate it's title" do
    @address.attributes = valid_address_attributes
    @address.title.should eql(valid_address_attributes[:title])
  end

  it "should populate it's street" do
    @address.attributes = valid_address_attributes
    @address.street.should eql(valid_address_attributes[:street])
  end
  
  it "should populate it's city" do
    @address.attributes = valid_address_attributes
    @address.city.should eql(valid_address_attributes[:city])
  end
      
  it "should have a valid short_line" do
    @address.attributes = valid_address_attributes
    @address.short_line.should eql("Orlando, Florida, United States")
  end
end

describe Address, ".auto_geocode" do
  include AddressSpecHelper

  before(:each) do
    @address = Address.new
    @address.attributes = valid_address_attributes
    
    
    @public_loc = GeoKit::GeoLoc.new(:lat => 28.5532, :lng => -81.3644)
    mock_geocode(@address.short_line, @public_loc)
  
    @exact_loc = GeoKit::GeoLoc.new(:lat => 28.55376, :lng => -81.4866)
    mock_geocode(@address.single_line, @exact_loc)
    @address.send(:auto_geocode)
  end
  
  it "should populate lat and lng" do
    @address.lat.should eql(@exact_loc.lat)
    @address.lng.should eql(@exact_loc.lng)
  end
  
  it "should populate public_lat and public_lng" do
      @address.public_lat.should eql(@public_loc.lat)
      @address.public_lng.should eql(@public_loc.lng)
  end
end