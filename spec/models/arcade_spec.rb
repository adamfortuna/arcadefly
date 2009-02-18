require File.dirname(__FILE__) + '/../spec_helper'

describe "Arcade associations" do
  before(:each) { Factory(:arcade) }
  subject { Arcade.new }
  
  it { should belong_to(:profile) }
  it { should have_many(:tags) }
  it { should have_many(:playables) }
  it { should have_many(:games).through(:playables) }
  it { should have_many(:frequentships) }
  it { should have_many(:profiles).through(:frequentships) }
  it { should have_many(:editors) }
  it { should have_many(:claims) }
  it { should have_one(:address) }
end

describe "Arcade validations" do
  before(:each) { Factory(:arcade) }
  subject { Arcade.new }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:name).with_message(/is required\./) }
  
  %w(http://test.com http://www.test.com http://www.test.com/test http://www.test.com/test.php http://www.test.org http://www.test.net).each do |value|
    it {should allow_value(value).for(:website)}
  end
  %w(test test.com http://test http:// http://.net http://.com http://.org).each do |value|
    it {should_not allow_value(value).for(:website)}
  end
  
  it {should allow_value("").for(:website)}
  it {should allow_value(nil).for(:website)}
end

describe "Arcade accessors" do
  before(:each) { Factory(:arcade) }
  subject { Arcade.new }  
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:phone) }
  it { should allow_mass_assignment_of(:notes) }
  it { should allow_mass_assignment_of(:all_tags) }
  it { should allow_mass_assignment_of(:address) }
  it { should allow_mass_assignment_of(:website) }
  it { should_not allow_mass_assignment_of(:profile) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  it { should_not allow_mass_assignment_of(:permalink_at) }
  it { should_not allow_mass_assignment_of(:profile_id) }
  it { should_not allow_mass_assignment_of(:playables_count) }
  it { should_not allow_mass_assignment_of(:frequentships_count) }
end


describe Arcade, ".to_param" do
  before(:each) do
    @arcade = Arcade.new
    @permalink = "example-permalink"
    @arcade.expects(:permalink).once.returns(@permalink)
  end
  it "should be equal to the permalink" do
    @arcade.to_param.should == @permalink
  end
end

describe Arcade, ".per_page" do
  it "should be equal 25" do
    Arcade.per_page.should == 25
  end
end

describe Arcade, ".title" do
  before(:each) do
    @arcade = Arcade.new
    @name = "Rocky's Replay"
    @arcade.expects(:name).once.returns(@name)
  end
  it "should be equal to the name" do
    @arcade.title.should == @name
  end
end

describe Arcade, ".has_profiles?" do
  before(:each) do
    @arcade = Arcade.new
  end
  it "should be true if lots of frequentships exist" do
    @arcade.expects(:frequentships).once.returns([1,2,3,4,5])
    @arcade.has_profiles?.should be_true
  end
  it "should be true if frequentships exist" do
    @arcade.expects(:frequentships).once.returns([1])
    @arcade.has_profiles?.should be_true
  end
  it "should not be true if frequentships are empty" do
    @arcade.expects(:frequentships).once.returns([])
    @arcade.has_profiles?.should be_false
  end
end

describe Arcade, ".has_games?" do
  before(:each) do
    @arcade = Arcade.new
  end
  it "should be true if lots of playables exist" do
    @arcade.expects(:playables).once.returns([1,2,3,4,5])
    @arcade.has_games?.should be_true
  end
  it "should be true if playables exist" do
    @arcade.expects(:playables).once.returns([1])
    @arcade.has_games?.should be_true
  end
  it "should not be true if playables are empty" do
    @arcade.expects(:playables).once.returns([])
    @arcade.has_games?.should be_false
  end
end

describe Arcade, ".has_game?" do
  before(:each) do
    @arcade = Arcade.new
    @game = mock('game')
    @playables = mock('playables')
    @arcade.expects(:playables).once.returns(@playables)
  end
  it "should be true if the arcade has this game" do
    @game.expects(:id).once.returns(1)
    @playables.expects(:find_by_game_id).once.with(1).returns([@game])
    @arcade.has_game?(@game).should be_true
  end
  it "should be false if the arcade doesn't have this game" do
    @game.expects(:id).once.returns(2)
    @playables.expects(:find_by_game_id).once.with(2).returns([])
    @arcade.has_game?(@game).should be_false
  end
end


describe Arcade, ".frequentships_rank" do
  before(:each) do
    @arcade = Factory(:arcade)
  end
  it "should be first if there is one only one arcade" do
    @arcade.frequentships_rank.should == 1
  end     
  it "should be first if there are multiple arcades with less frequentships" do
    Factory(:arcade, :frequentships_count => 1)
    @arcade.frequentships_rank.should == 1
  end
  it "should be in the middle if multiple arcades have more and less frequentships" do
    Factory(:arcade, :frequentships_count => 1)
    Factory(:arcade, :frequentships_count => 20)
    @arcade.frequentships_rank.should == 2
  end
  it "should be last if all arcades have more frequentships" do
    Factory(:arcade, :frequentships_count => 20)
    Factory(:arcade, :frequentships_count => 30)
    Factory(:arcade, :frequentships_count => 40)
    @arcade.frequentships_rank.should == 4
  end
  it "should be ranked tied with others of the same count" do
    Factory(:arcade)
    @arcade.frequentships_rank.should == 1
  end
  it "should be ranked tied with others of the same count and in the middle" do
    Factory(:arcade, :frequentships_count => 20)
    Factory(:arcade, :frequentships_count => 30)
    Factory(:arcade, :frequentships_count => 10)
    @arcade.frequentships_rank.should == 3
  end  
end

describe Arcade, ".playables_rank" do
  before(:each) do
    @arcade = Factory(:arcade)
  end
  it "should be first if there is one only one arcade" do
    @arcade.playables_rank.should == 1
  end
  it "should be first if there are multiple arcades with less playables" do
    Factory(:arcade, :playables_count => 1)
    @arcade.playables_rank.should == 1
  end
  it "should be in the middle if multiple arcades have more and less playables" do
    Factory(:arcade, :playables_count => 1)
    Factory(:arcade, :playables_count => 20)
    @arcade.playables_rank.should == 2
  end
  it "should be last if all arcades have more playables" do
    Factory(:arcade, :playables_count => 20)
    Factory(:arcade, :playables_count => 30)
    Factory(:arcade, :playables_count => 40)
    @arcade.playables_rank.should == 4
  end
  it "should be ranked tied with others of the same count" do
    Factory(:arcade)
    @arcade.playables_rank.should == 1
  end
  it "should be ranked tied with others of the same count and in the middle" do
    Factory(:arcade, :playables_count => 20)
    Factory(:arcade, :playables_count => 30)
    Factory(:arcade, :playables_count => 10)
    @arcade.playables_rank.should == 3
  end
end

describe Arcade, ".all_tags=" do
  before(:each) do
    @arcade = Arcade.new
  end
  it "should take in a string of tags and set them to tag_list" do
    @arcade.all_tags = ["one","two","three"]
    @arcade.tag_list.should == ["one","two","three"]
  end
  it "should take an array of tags and convert them to a comma separated string" do
    @arcade.all_tags = "one,two,three"
    @arcade.tag_list.should == ["one","two","three"]
  end
end

describe Arcade, ".has_hours?" do
  before(:each) do
    @arcade = Arcade.new
  end
  
  it "should not have hours" do
    @arcade.has_hours?.should be_false
  end
end