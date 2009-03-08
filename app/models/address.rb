class Address < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to            :addressable, :polymorphic => true
  belongs_to            :region
  belongs_to            :country

  acts_as_mappable :auto_geocode => false

  validates_presence_of :street,
                        :city,
                        :country_id,
                        :lat,
                        :lng
  validates_presence_of :region_id,
                        :if => :known_region_required?

  before_validation_on_create :auto_geocode
  before_validation_on_update :check_for_auto_geocode

  attr_accessor :geocoded#, :country_name, :region_name
  
  # Returns the region's country if the region is specified
#  def country_with_region_check
#    (region && region.country != nil) ? region.country : country_without_region_check
#  end
#  alias_method_chain :country, :region_check


  # def country_name
  #   self.country_id? ? country.alpha_2_code : self['country_name']
  # end
  
  def blank?
    region_id.blank? && country_id.blank? && postal_code.blank? && street.blank? && city.blank?
  end
  
  def region?
    self.region_id? ? true : (region && !region.name.blank?)
  end
  alias :has_region? :region

  def country?
    self.country_id? ? true : (country && !country.name.blank?)
  end
  alias :has_country? :country

  # def region_name
  #   self.region_id? ? region.abbreviation : self['region_name']
  # end

  def public_lat
    addressable_type == "Arcade" ? lat : self[:public_lat]
  end
  
  def public_lng
    addressable_type == "Arcade" ? lng : self[:public_lng]
  end

  def shortest_line
    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.abbreviation
    end
    line << ', ' if !line.blank?
    line << country.alpha_3_code if country
    line
  end
  memoize :shortest_line
  
  # This is the default way an address will be displayed.
  # Currently: Orlando, Florida United States of America
  def short_line
    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.name if region?
    end
    line << ', ' if !line.blank?
    line << country.name if country?
    line = 'No Address' if line.blank?
    line
  end
  memoize :short_line

  # Gets the value of the address on a single line.
  def single_line
    multi_line.join(', ')
  end
  memoize :single_line

  # Gets the value of the address on multiple lines.
  def multi_line
    lines = []
    lines << street if street?

    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.name if region?
    end
    if postal_code?
      line << '  ' if !line.blank?
      line << postal_code.to_s
    end
    lines << line if !line.blank?

    lines << country.alpha_3_code if country?
    lines
  end
  memoize :multi_line
  
  def full_single_line
    full_line.join(', ')
  end
  memoize :full_single_line

  def full_line
    lines = []
    lines << street if street?

    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.name if region?
    end
    if postal_code?
      line << '  ' if !line.blank?
      line << postal_code.to_s
    end
    lines << line if !line.blank?

    lines << country.name if country?
    lines
  end
  memoize :full_line
  
  def self.geocode(address)
    GeoKit::Geocoders::GoogleGeocoder.geocode(address)
  end
  
  def self.iplookup(ip)
    GeoKit::Geocoders::IpGeocoder.geocode(ip)
  end  
  
  protected
  def check_for_auto_geocode
    auto_geocode if changed?
  end
  def auto_geocode
    return if self.geocoded
    
    self.geocoded = true
    # Exact location
    return false if geocoded_address.lat.nil? || geocoded_address.lng.nil?

    self.lat = geocoded_address.lat
    self.lng  = geocoded_address.lng

    # Use returned data for this address rather than the user entered data
    self.postal_code = geocoded_address.zip
    self.city = geocoded_address.city
    self.street = geocoded_address.street_address

    # General Location
    public_loc = geocoded_general_address
    self.public_lat = public_loc.lat
    self.public_lng  = public_loc.lng
  end
  
  private
  
  # Since some countries are not divided into regions, we shouldn't require a region for all addresses.
  # A region should be provided if the country they selected has more than one region available though.
  #
  # cat:: Convenience Method
  #
  # Example:
  #  USA.known_region_required? => true
  def known_region_required?
    return false if country == nil
    country.regions.count != 0
  end
  
  def geocoded_address
    Address.geocode(full_single_line)
  end
  memoize :geocoded_address

  def geocoded_general_address
    Address.geocode("#{geocoded_address.city}, #{geocoded_address.state} #{geocoded_address.zip}")
  end
  memoize :geocoded_general_address
  
  
end