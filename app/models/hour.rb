class Hour < ActiveRecord::Base
  belongs_to :timeable, :polymorphic => true  
  # Todo: Add a validation rule to make sure start time is before end
end