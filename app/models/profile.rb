class Profile < ActiveRecord::Base
  belongs_to :user
  
  PER_PAGE = 50
  
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "is taken. Do you already have an account here? <a href=\"/signin\">Yes i do!</a>"
  validates_format_of :email, :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>'does not look like an email address.'
  validates_length_of :email, :within => 3..100    
  validates_confirmation_of :email,                   :if => :email_required?

  validates_length_of :display_name, :within => 3..100
  
  
  validates_associated :address
  
  # Arcades
  has_many :frequentships
  has_many :arcades, :through => :frequentships

  # Games
  has_many :favoriteships
  has_many :games, :through => :favoriteships

  # Friends
  has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPTED}"
  has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING}"
  has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING}"
  
  has_many :friends,   :through => :friendships, :source => :invited
  has_many :followers, :through => :follower_friends, :source => :inviter
  has_many :followings, :through => :following_friends, :source => :invited
  
  # Addresses
  has_one :address, :as => :addressable
  
  # Messages
  has_many :sent_messages,     :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'receiver_id'
  has_many :unread_messages,   :class_name => 'Message', :conditions => ["read=?",false] 
  
  # Comments and Blogs
  has_many :comments, :as => :commentable, :order => 'created_at desc'
  has_many :blogs, :order => 'created_at desc'
  
  # Photos
  has_many :photos, :order => 'created_at DESC'
  
  # Feeds
  has_many :feeds
  has_many :feed_items, :through => :feeds, :order => 'created_at desc'
  has_many :private_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => false}, :order => 'created_at desc'
  has_many :public_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => true}, :order => 'created_at desc'
  
  #acts_as_ferret :fields => [ :f, :about_me ], :remote=>true
  
  file_column :icon, :magick => {
    :versions => { 
      :big => {:crop => "1:1", :size => "150x150", :name => "big"},
      :medium => {:crop => "1:1", :size => "100x100", :name => "medium"},
      :small => {:crop => "1:1", :size => "50x50", :name => "small"}
    }
  }
  
  cattr_accessor :featured_profile
  @@featured_profile = {:date=>Date.today-4, :profile=>nil}
  Profile::NOWHERE = 'Nowhere'

  def to_param
    "#{id}-#{url_safe(display_name)}"
  end
  
  
  def url_safe(param)
    param.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
  end
  
  
  # Used for pagination of a search term given the current page. The number of users per page
  # isn't customizable for the user and is set to a static number within this model.
  #
  # = Example
  #  User.search("dance", 2) => Pagination Array
  def self.search(search, page)
    search = "%#{search}" if search and search.length >= 2
    if search == '#'
      paginate :per_page => PER_PAGE, :page => page,
               :conditions => ['display_name regexp "^[0-9]+"'],
               :include => { :profile => [:address => [:region, :country]] },
               :order => 'display_name'
    else
      paginate :per_page => PER_PAGE, :page => page,
               :conditions => ['display_name like ?', "#{search}%"],
               :include => { :profile => [:address => [:region, :country]] },
               :order => 'display_name'
    end
  end


  
  
  def has_network?
    !Friend.find(:first, :conditions => ["inviter_id = ? or invited_id = ?", id, id]).blank?
  end
  
  
  
  def self.featured
    find_options = {
      :include => :user,
      :conditions => ["users.active = ? and about_me IS NOT NULL and user_id is not null", true],
    }
    find(:first, find_options.merge(:offset => rand( count(find_options) - 1)))
  end  
  
  def no_data?
    (created_at <=> updated_at) == 0
  end
  
  
  
  
  def has_wall_with profile
    return false if profile.blank?
    !Comment.between_profiles(self, profile).empty?
  end
  
  
  
  
  
  def website= val
    write_attribute(:website, fix_http(val))
  end
  def blog= val
    write_attribute(:blog, fix_http(val))
  end
  
  
  
  
  
  # Friend Methods
  def friend_of? user
    user.in? friends
  end
  
  def followed_by? user
    user.in? followers
  end
  
  def following? user
    user.in? followings
  end
  
  
  
  
  
  def has_favorite_arcade?(arcade)
    Frequentship.find_by_profile_id_and_arcade_id(id, arcade.id, :select => 'true')
    # (arcades.collect do |a| a.id end).include?(arcade.id)
  end
  
  def has_favorite_game?(game)
    Favoriteship.find_by_profile_id_and_game_id(id, game.id, :select => 'true')
    # (games.collect do |a| a.id end).include?(game.id)
  end
  
  
  
  
  
  
  def has_address?
    address && (!address.nil? || address.new_record?)
  end
  
  def country_id
    address.country.id
  end
  
  def region_id
    address.region.id
  end
  
  
  
  
  
  
  
  
  
  # Returns a Gravatar URL associated with the email parameter.
  def gravatar_url(gravatar_options={})

    # Default highest rating.
    # Rating can be one of G, PG, R X.
    # If set to nil, the Gravatar default of X will be used.
    gravatar_options[:rating] ||= nil

    # Default size of the image.
    # If set to nil, the Gravatar default size of 80px will be used.
    gravatar_options[:size] ||= nil 

    # Default image url to be used when no gravatar is found
    # or when an image exceeds the rating parameter.
    gravatar_options[:default] ||= nil

    # Build the Gravatar url.
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << "gravatar_id=#{Digest::MD5.new.update(email)}" 
    grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
    grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
    grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
    return grav_url
  end
  
  
  
  
  
  
  def can_send_messages
    user.can_send_messages
  end
  
  
  
  
  def validate
    if address && !address.valid?
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
  
  
  
  
  def self.search query = '', options = {}
    query ||= ''
    q = '*' + query.gsub(/[^\w\s-]/, '').gsub(' ', '* *') + '*'
    options.each {|key, value| q += " #{key}:#{value}"}
    arr = find_by_contents q, :limit=>:all
    logger.debug arr.inspect
    arr
  end
  
  
  
  protected
  def fix_http str
    return '' if str.blank?
    str.starts_with?('http') ? str : "http://#{str}"
  end
  
  def email_required?
    email.blank? || !email_confirmation.nil?
  end
  
  
end
