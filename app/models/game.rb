class Game < ActiveRecord::Base
  has_many :playables
  has_many :arcades, :through => :playables

  has_many :favoriteships
  has_many :users, :through => :favoriteships
  
  validates_presence_of :name

  # This controls how many ames will be shown per page to the user.
  cattr_reader :per_page
  @@per_page = 50
  
  # Used for pagination of a search term given the current page. The number of games per page
  # isn't customizable for the user and is set to a static number within this model.
  #
  # = Example
  #  Game.search("dance", 2) => Pagination Array
  def self.search(search, page)
    search = "%#{search}" if search and search.length >= 2
    
    		
    if search == '#'
      paginate :per_page => @@per_page, :page => page,
             :conditions => ['name regexp "^[0-9]+"'],
             :order => 'name'
    else
      paginate :per_page => @@per_page, :page => page,
             :conditions => ['name like ?', "#{search}%"],
             :order => 'name'
    end
  end
  
  def to_param
    "#{id}-#{url_safe(name)}"
  end
  
  
  def url_safe(param)
    param.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
  end
end