require File.dirname(__FILE__) + '/../spec_helper'

describe Arcade do
  
  before(:each) do
    @arcade = Arcade.new
  end

  it "should have errors" do
    @arcade.should have(1).error_on(:name)
  end
end