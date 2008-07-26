module Addressable

  def self.included(receiver)
    receiver.class_eval do
      acts_as_mappable
      
      has_one :address, :as => :addressable, :accessible => true
    	delegate [:lat, :lng, :country_id, :region_id], :to => :address
      
      before_validation :validate_address
      
      validates_presence_of :address
    	validates_associated :address
    end
  end
  
  def map_bubble
    raise "Map bubble"
  end

  def has_address?
    !address.nil?
  end

  def validate_address
    if address && !address.valid?
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
end