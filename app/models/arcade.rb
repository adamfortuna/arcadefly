class Arcade < ActiveRecord::Base
	has_many :playables
	has_many :frequentships
	has_many :games, :through => :playables
	has_many :users, :through => :frequentships
	has_one :address, :as => :addressable
	
	has_many :hours, :as => :timeable, :order => 'dayofweek, start, end'
	
	acts_as_mappable
	  
	attr_accessor :game_ids
	after_save :update_games
	after_create :update_address
	
	#after_destroy :update_playables_count
	#after_destroy :update_frequentships_count
	
	validates_presence_of :name, :message => "is required."
	validates_presence_of :address
	validates_associated :address
	
	PER_PAGE = 30
	
	# Method for paginating search. This will return a Pagination object
	# which can be used in the same way as the result of a regular find
	# except that it will have additional pagination information.
	def self.search(search, page)
		search = "%#{search}" if search and search.length >= 2
		paginate :per_page => PER_PAGE, :page => page,
						 :conditions => ['arcades.name like ?', "#{search}%"],
		         :order => 'arcades.name, frequentships_count desc',
						 :include => [{:address => [:region, :country]}]
	end
  	
  def self.search_by_region(region_id, page)
		paginate :per_page => PER_PAGE, :page => page,
						 :conditions => ['addresses.region_id = ?', region_id],
		         :order => 'addresses.city, arcades.name',
						 :include => [{:address => [:region, :country]}]
	end
	
  def self.search_by_country(country_id, page)
		paginate :per_page => PER_PAGE, :page => page,
						 :conditions => ['addresses.country_id = ?', country_id],
		         :order => 'regions.name, addresses.city, arcades.name',
						 :include => [{:address => [:region, :country]}]
	end

  def to_param
    "#{id}-#{url_safe(name)}"
  end
  
  def lat
    address.lat
  end

  def lng
    address.lng
  end

  def url_safe(param)
    param.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
  end
	  
	private
		# after_save callback to handle group_ids
		def update_games
			unless game_ids.nil?
				self.playables.each do |p|
					p.destroy unless game_ids.include?(p.game_id.to_s)
					game_ids.delete(p.game_id.to_s)
				end 
				game_ids.each do |g|
					self.playables.create(:game_id => g, :count => 1) unless g.blank?
				end
				reload
			end
		end
		
		def update_address
		  address.save!
		end
	
	#def update_playables_count
	#end
	#def update_frequentships_count
  #end
	
end