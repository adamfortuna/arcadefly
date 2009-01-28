module Addressable

  def self.included(receiver)
    receiver.class_eval do
      acts_as_mappable :mappable => :address
      
      has_one :address, :as => :addressable, :dependent => :destroy#, :accessible => true
    	delegate [:lat, :lng, :country_id, :region_id], :to => :address

      after_validation :add_address_errors_to_base
    end
  end

  def lat
    address.lat
  end
  
  def lng
    address.lng
  end
  
  def map_bubble
    raise "Map bubble"
  end

  def has_address?
    !address.nil?
  end

  def add_address_errors_to_base
    address.valid? if address
    if address && address.errors
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
end