class Game < ActiveRecord::Base
  PUBLIC_FIELDS = [:name, :gamefaqs_id, :favoriteships_count, :playables_count, :permalink]
  has_permalink :gamefaqs_id
  
  has_many :playables
  has_many :arcades, :through => :playables

  has_many :favoriteships
  has_many :profiles, :through => :favoriteships
  
  # Validation
  validates_presence_of :name

  def self.per_page
    100
  end

  def to_param
    permalink
  end    
    
  def has_arcades?
    playables.size > 0
  end
  
  def has_users?
    favoriteships.size > 0
  end

  def favoriteships_rank
    Game.count(:conditions => ['favoriteships_count > ?', favoriteships_count]) + 1
  end
  
  def playables_rank
    Game.count(:conditions => ['playables_count > ?', playables_count]) + 1
  end
end