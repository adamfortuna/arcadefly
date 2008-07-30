class Arcade < ActiveRecord::Base
  include Addressable

	PUBLIC_FIELDS = [:created_at, :updated_at, :permalink, :name, :phone, :website, :notes, :playables_count, :frequentships_count]
	PUBLIC_FIELDS_WITH_ADDRESS = [PUBLIC_FIELDS, :street, :city, :postal_code, :lat, :lng].flatten

	has_permalink :name
  
	has_many :playables
	has_many :games, :through => :playables

	has_many :frequentships
	has_many :profiles, :through => :frequentships

	has_many :hours, :as => :timeable, :order => 'day, start, end'
		
	# Validations
	validates_associated :address
	validates_presence_of :name, :message => "is required."
	validates_uniqueness_of :permalink
	
	def to_param
    permalink
  end

  def self.per_page
    25
  end

  def has_profiles?
    frequentships.size > 0
  end
  
  def has_games?
    playables.size > 0
  end

  def has_game?(game)
    playables.find_by_game_id(game.id)
  end

  def frequentships_rank
    Arcade.count(:conditions => ['frequentships_count > ?', frequentships_count]) + 1
  end
  
  def playables_rank
    Arcade.count(:conditions => ['playables_count > ?', playables_count]) + 1
  end

  def has_hours?
    false
  end

  def map_bubble
    "<strong>#{self.name}</strong> <p>#{self.address.street}<br />#{self.address.city}, #{self.address.region.name} #{self.address.postal_code}</p><p><strong>Games:</strong> #{self.playables_count}</p>"
  end
	
	
	# For iUi
	def caption
	  name
	end	
	
	def url
	  "http://www.arcadefly.com/arcades/#{permalink}"
	end
	
end