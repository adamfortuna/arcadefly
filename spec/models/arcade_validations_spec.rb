# require File.dirname(__FILE__) + '/../spec_helper'
# 
# describe Arcade, :shared => true do
#   before(:all) do
#     @arcade = Arcade.new
#     @address = Address.new({:geocoded => true, :street => '1234 Test Street', :region_id => 1, :country_id => 1, :city => "Orlando", :lat => 12.341, :lng => 42.23})
#     @name = "Testing this out"
#   end
# end
# 
# describe Arcade, "validates_presence_of :address, validates_associated :address" do
#   it_should_behave_like "Arcade"
#   before(:all) do
#     @arcade.name = @name
#   end
# 
#   it "should be invalid" do
#     @arcade.valid?.should be_false
#   end
# 
#   it "should have an error on address" do
#     @arcade.valid?
#     @arcade.errors["address"].should_not be_nil
#   end
# 
#   it "should have an error on address that it can't be blank" do
#     @arcade.valid?
#     @arcade.errors["address"].should == "can't be blank"
#   end
# 
#   it "should have an error if the address is invalid" do
#     @arcade.address = Address.new(:geocoded => true)
#     @arcade.valid?
#     @arcade.errors["address"].should == "is invalid"
#   end
#   
#   it "should be valid if the arcade and address are valid" do
#     @arcade.address = @address
#     @arcade.valid?.should be_true
#   end
# end
# 
# describe Arcade, "validates_presence_of :name" do
#   it_should_behave_like "Arcade"
#   before(:all) do
#     @arcade.address = @address
#   end
#   
#   it "should be invalid" do
#    @arcade.valid?.should be_false 
#   end
#   
#   it "should have an error on name" do
#     @arcade.valid?
#     @arcade.errors["name"].should_not be_nil
#   end
# 
#   it "should have an error on name that it is required" do
#     @arcade.valid?
#     @arcade.errors["name"].should == "is required."
#   end
# 
#   it "should have an error if the name is empty" do
#     @arcade.name = ''
#     @arcade.valid?
#     @arcade.errors["name"].should == "is required."
#   end
#   
#   it "should be valid if the arcade name is valid" do
#     @arcade.name = @name
#     @arcade.valid?.should be_true
#   end
# end
# 
# describe Arcade, "validates_uniqueness_of :permalink" do
#   it_should_behave_like "Arcade"
#   before(:all) do
#     @arcade.address = @address
#     @arcade.name = @name
#   end
#   
#   it "should set the permalink" do
#    @arcade.valid?.should be_true
#    @arcade.permalink.should == "testing-this-out"
#   end
# end