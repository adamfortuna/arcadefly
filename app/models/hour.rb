class Hour < ActiveRecord::Base
  belongs_to :timeable, :polymorphic => true
  
  validates_presence_of :dayofweek, :start, :end
  
  validates_format_of   :dayofweek,
                        :with => /^[0-6]$/,
                        :message => "must be a valid day of the week"
                        
  # Todo: Add a validation rule to make sure start time is before end
                          
end