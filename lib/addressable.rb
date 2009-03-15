module Addressable
  extend ActiveSupport::Memoizable

  def self.included(receiver)
    receiver.class_eval do
      acts_as_mappable :mappable => :address
      
      has_one :address, :as => :addressable, :dependent => :destroy#, :accessible => true
    	delegate :lat, :to => :address
    	delegate :lng, :to => :address
      #after_validation :add_address_errors_to_base
    end
  end
  
  def has_address?
    !address.nil?
  end
  
  def maplink
    return "point-#{(address.public_lat+address.public_lng).hash}"
  end
  memoize :maplink

  # def add_address_errors_to_base
  #   address.valid? if address
  #   if address && address.errors
  #     address.errors.each { |attr, msg| errors.add(attr, msg) }
  #   end
  # end  
end