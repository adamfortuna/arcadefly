class Address < ActiveRecord::Base
  belongs_to            :addressable, :polymorphic => true
  belongs_to            :region
  belongs_to            :country

  acts_as_mappable

  validates_presence_of :city,
                        :postal_code,
                        :country_id
  validates_presence_of :region_id,
                        :if => :known_region_required?
  validates_format_of   :postal_code,
                        :with => /^[0-9]{5}$/,
                        :allow_nil => true,
                        :message => "must be a valid 5 digit code"

  before_save           :auto_geocode

  # Returns the region's country if the region is specified
#  def country_with_region_check
#    (region && region.country != nil) ? region.country : country_without_region_check
#  end
#  alias_method_chain :country, :region_check

  # This is the default way an address will be displayed.
  # Currently: Orlando, Florida United States of America
  def short_line
    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.name
    end
    line << ', ' if !line.blank?
    line << country.name if country
    line = 'No Address' if line.blank?
    line
  end

  # Gets the value of the address on a single line.
  def single_line
    multi_line.join(', ')
  end

  # Gets the value of the address on multiple lines.
  def multi_line
    lines = []
    lines << street if street?

    line = ''
    line << city if city?
    if region
      line << ', ' if !line.blank?
      line << region.abbreviation
    end
    if postal_code?
      line << '  ' if !line.blank?
      line << postal_code.to_s
    end
    lines << line if !line.blank?

    lines << country.alpha_2_code if country
    lines
  end
  
  def self.geocode(address)
    GeoKit::Geocoders::GoogleGeocoder.geocode(address)
  end
  
  protected
  def auto_geocode
    # Exact location
    exact_loc = Address.geocode(single_line)
    self.lat = exact_loc.lat
    self.lng  = exact_loc.lng

    # General Location
    public_loc = Address.geocode(short_line)
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
end