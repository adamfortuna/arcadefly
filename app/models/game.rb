class Game < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  PUBLIC_FIELDS = [:id, :name, :gamefaqs_id, :klov_id, :favoriteships_count, :playables_count, :permalink, :alias]
  PER_PAGE = 100
  has_permalink :name
  
  has_many :playables, :dependent => :destroy
  has_many :arcades, :through => :playables

  has_many :favoriteships, :dependent => :destroy
  has_many :profiles, :through => :favoriteships
  
  belongs_to :profile
  named_scope :pending, :conditions => ['pending = ?', true]
  
  # Validation
  validates_presence_of :name
	validates_uniqueness_of :gamefaqs_id, :if => :gamefaqs_id?
	validates_uniqueness_of :klov_id, :if => :klov_id?
	validates_uniqueness_of :permalink

  # define_index do
  #   indexes :name, :sortable => true
  #   indexes :alias
  #   
  #   has created_at, updated_at, favoriteships_count, playables_count
  # end

  def self.per_page
    PER_PAGE
  end

  def to_param
    permalink
  end    
    
  def has_arcades?
    playables.size > 0
  end
  memoize :has_arcades?
  
  def has_users?
    favoriteships.size > 0
  end
  memoize :has_users?

  def favoriteships_rank
    Game.count(:conditions => ['favoriteships_count > ?', favoriteships_count]) + 1
  end
  memoize :favoriteships_rank
  
  def playables_rank
    Game.count(:conditions => ['playables_count > ?', playables_count]) + 1
  end
  memoize :playables_rank
  
  def self.recent
    self.find(:all, :order => 'favoriteships_count desc, playables_count desc', :limit => 10)
  end
  
  def approve!
    self.update_attribute(:pending, false) if self.pending?
  end
end