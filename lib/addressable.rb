module Addressable

  def self.included(receiver)
    receiver.class_eval do
      acts_as_mappable
      
      has_one :address, :as => :addressable#, :accessible => true
    	delegate [:lat, :lng, :country_id, :region_id], :to => :address

      after_validation :add_address_errors_to_base
    end
  end
  
  def map_bubble
    raise "Map bubble"
  end

  def has_address?
    !address.nil?
  end

  def add_address_errors_to_base
    if address && address.errors
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
end