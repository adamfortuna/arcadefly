# Defined by the ISO 3166-2 standard
class Region < ActiveRecord::Base
  belongs_to              :country
  has_many                :addresses

  validates_presence_of   :name,
                          :country,
                          :abbreviation

  validates_length_of     :name, :within => 2..80
  validates_length_of     :abbreviation, :within => 2..5

  validates_uniqueness_of :name, :scope => :country_id
  validates_uniqueness_of :abbreviation, :scope => :country_id

  def to_param
    "#{id}-#{url_safe(name)}"
  end
  
  def url_safe(param)
    param.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
  end
  
  def to_s #:nodoc
    name
  end
end