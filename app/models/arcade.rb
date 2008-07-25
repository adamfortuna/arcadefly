class Arcade < ActiveRecord::Base
  include Addressable

	PER_PAGE = 25
	PUBLIC_FIELDS = [:created_at, :updated_at, :permalink, :name, :phone, :website, :notes, :playables_count, :frequentships_count]
	PUBLIC_FIELDS_WITH_ADDRESS = [PUBLIC_FIELDS, :street, :city, :postal_code, :lat, :lng].flatten
	attr_accessor :game_ids

	has_permalink :name
  
	has_many :playables
	has_many :games, :through => :playables

	has_many :frequentships
	has_many :profiles, :through => :frequentships

	has_many :hours, :as => :timeable, :order => 'day, start, end'
	
	after_save :update_games
	
	# Validations
	validates_presence_of :name, :message => "is required."
	validates_uniqueness_of :permalink
	
	def to_param
    permalink
  end

  def has_profiles?
    frequentships.size > 0
  end
  
  def has_games?
    playables.size > 0
  end

  def frequentships_rank
    Arcade.count(:conditions => ['frequentships_count > ?', frequentships_count]) + 1
  end
  
  def playables_rank
    Arcade.count(:conditions => ['playables_count > ?', playables_count]) + 1
  end

	def add_game(game_id, games_count)
	  self.playables.create(:game => Game.find(game_id), :games_count => games_count)
  end
  
  def has_hours?
    true
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
			#reload
		end
	end
		
end