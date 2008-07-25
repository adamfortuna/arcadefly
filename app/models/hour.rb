class Hour < ActiveRecord::Base
  belongs_to :timeable, :polymorphic => true  
  # Todo: Add a validation rule to make sure start time is before end

  START_OPTIONS = ["12:00 AM", "6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM", "9:00 AM", "9:30 AM", 
    "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM",
    "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM", "6:00 PM", "6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM",
    "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM", "12:00 AM", "12:30 AM", "1:00 AM", "1:30 AM", "2:00 AM", "2:30 AM", "3:00 AM"]
  END_OPTIONS = START_OPTIONS
  
  def self.create_week(timeable)
    [ Hour.new(:dayofweek => 'mon', :start => Time.now, :end => Time.now, :day => 0, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'tue', :start => Time.now, :end => Time.now, :day => 1, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'wed', :start => Time.now, :end => Time.now, :day => 2, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'thu', :start => Time.now, :end => Time.now, :day => 3, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'fri', :start => Time.now, :end => Time.now, :day => 4, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'sat', :start => Time.now, :end => Time.now, :day => 5, :closed => false, :timeable => timeable),
      Hour.new(:dayofweek => 'sun', :start => Time.now, :end => Time.now, :day => 6, :closed => false, :timeable => timeable)
    ]
  end
end