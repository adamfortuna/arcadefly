class Game < ActiveRecord::Base
  PUBLIC_FIELDS = [:name, :gamefaqs_id, :klov_id, :favoriteships_count, :playables_count, :permalink]
  PER_PAGE = 100
  has_permalink :name
  
  has_many :playables
  has_many :arcades, :through => :playables

  has_many :favoriteships
  has_many :profiles, :through => :favoriteships
  
  # Validation
  validates_presence_of :name

  define_index do
    indexes :name, :sortable => true
    indexes :alias
    
    has created_at, updated_at, favoriteships_count, playables_count
  end


  def self.per_page
    PER_PAGE
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