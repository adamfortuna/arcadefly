class Arcade < ActiveRecord::Base
  include Addressable
  acts_as_taggable

	PUBLIC_FIELDS = [:created_at, :updated_at, :permalink, :name, :phone, :website, :notes, :playables_count, :frequentships_count]
	PUBLIC_FIELDS_WITH_ADDRESS = [PUBLIC_FIELDS, :street, :city, :postal_code, :lat, :lng].flatten

	has_permalink :name
  
  belongs_to :profile
	has_many :playables
	has_many :games, :through => :playables

	has_many :frequentships
	has_many :profiles, :through => :frequentships

	has_many :hours, :as => :timeable, :order => 'day, start, end'
	
	has_many :claims
	
	# Validations
	validates_associated :address
	validates_presence_of :name, :message => "is required."
	validates_uniqueness_of :permalink

  attr_accessible :name, :phone, :all_tags, :address, :profile, :website

	def to_param
    permalink
  end

  def self.per_page
    25
  end

  def title
    name
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
	
	# For iUi
	def caption
	  name
	end	
	
  def all_tags=(current_tags)
    if(current_tags.is_a?(Array))
      self.tag_list = current_tags.join(',')
    else
      self.tag_list = current_tags
    end
  end
  
  protected
  after_create :create_claim
	def create_claim
	  claims << Claim.create(:profile => self.profile, :level => 0, :approved => true, :name => self.profile.display_name, :reason => "Added arcade to ArcadeFly")
  end
	
end