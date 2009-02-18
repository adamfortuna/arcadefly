require File.dirname(__FILE__) + '/../spec_helper'

describe "Addressable associations" do
  before(:each) { Factory(:addressable) }
  subject { Arcade.new }
  
  it { should have_one(:address) }
end

describe Addressable, ".has_address?" do
  before(:each) { @addressable = Arcade.new({:address => Address.new}) }
  
  it "should be true for a new addressable" do
    Arcade.new.has_address?.should be_false
  end
  
  it "should be false if there is no address" do
    @addressable.has_address?.should be_true
  end
  
  it "should be false after nilifying an addres" do
    @addressable.address = nil
    @addressable.has_address?.should be_false
  end
end

describe Addressable, "delegations" do
  before(:each) do
    @addressable = Arcade.new({ :address => Address.new({:street      => "1130 Summer Lakes Drive",
                                                         :city        => "Orlando",
                                                         :region_id   => 1,
                                                         :country_id  => 4,
                                                         :postal_code => "32835",
                                                         :lat         => 23.234234,
                                                         :lng         => 65.342342 }) })
  end

  it "should delegate addressable.lat to address.lat" do
    @addressable.lat.should == @addressable.address.lat
  end
  it "should delegate addressable.lng to address.lng" do
    @addressable.lng.should == @addressable.address.lng
  end  
end