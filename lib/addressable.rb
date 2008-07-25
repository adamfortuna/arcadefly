module Addressable

  def self.included(receiver)
    receiver.class_eval do
      acts_as_mappable
      
      has_one :address, :as => :addressable, :accessible => true
    	delegate [:lat, :lng], :to => :address
    	#after_create :update_address

      validates_presence_of :address
    	validates_associated :address
    
    
    end
  end
  
    
    
    def has_address?
      !address.nil?
    end


  	# def update_address
  	#      address.save!
  	#    end
	
  
end