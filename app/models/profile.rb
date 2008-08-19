class Profile < ActiveRecord::Base
  include Addressable

  PUBLIC_FIELDS = [:created_at, :display_name, :favoriteships_count, :frequentships_count, :friendships_count, :full_name, :initials, :permalink, :website]
  PER_PAGE = 30

  #before_validation :reset_permalink
  has_permalink :display_name

  attr_accessor :icon

  define_index do
    indexes :display_name, :sortable => true
    indexes :initials, :full_name, :about_me, :aim_name, :gtalk_name, :msn_name
    has created_at, updated_at, favoriteships_count, frequentships_count
  end

  # User
  belongs_to :user, :dependent => :destroy

  # Claims
  has_many :claims, :dependent => :destroy
  has_many :claimed_arcades, :through => :claims, :source => :arcade

  # Arcades
  has_many :frequentships, :dependent => :destroy
  has_many :arcades, :through => :frequentships

  # Games
  has_many :favoriteships, :dependent => :destroy
  has_many :games, :through => :favoriteships
  
  # Messages
  has_many :sent_messages,     :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'receiver_id'
  has_many :unread_messages,   :class_name => 'Message', :conditions => ["read=?",false]
  
  # Comments 
  has_many :comments, :as => :commentable, :order => 'created_at desc'

  # Friends
  has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPTED}", :dependent => :destroy
  has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING}", :dependent => :destroy
  has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING}", :dependent => :destroy
  
  has_many :friends,   :through => :friendships, :source => :invited
  has_many :followers, :through => :follower_friends, :source => :inviter
  has_many :followings, :through => :following_friends, :source => :invited
  
  # Validation
  validates_length_of :display_name, :within => 3..100
  

  def to_param
    permalink
  end
  
  def self.per_page
    PER_PAGE
  end
  
  def title
    display_name
  end
  
  
  def website= val
    write_attribute(:website, fix_http(val))
  end
  
  
  
  
  
  # Friend Methods
  def has_network?
    !Friend.find(:first, :conditions => ["inviter_id = ? or invited_id = ?", id, id]).blank?
  end

  def friend_of? profile
    user.in? friends
  end
  
  def followed_by? profile
    user.in? followers
  end
  
  def following? profile
    user.in? followings
  end
  
  
  
  
  # ==============================
  # = Favorite Arcades and Games =
  # ==============================
  def has_arcades?
    frequentships.length > 0
  end

  def has_favorite_arcade?(arcade)
    favorite_arcade_ids.include?(arcade.id)
  end

  def favorite_arcade_ids
    @cached_favorite_arcade_ids ||= frequentships.find(:all, :select => :arcade_id).collect(&:arcade_id)
  end
  
  def has_games?
    favoriteships.length > 0
  end

  def has_favorite_game?(game)
    favorite_game_ids.include?(game.id)
  end

  def favorite_game_ids
    @cached_favorite_game_ids ||= favoriteships.find(:all, :select => :game_id).collect(&:game_id)
  end
  
  def pending_claim?(arcade)
    pending_claimed_arcade_ids.include?(arcade.id)
  end

  def pending_claimed_arcade_ids
    @cached_pending_claimed_arcade_ids ||= claims.find(:all, :select => :arcade_id, :conditions => {:approved => 0}).collect(&:arcade_id)
  end
  
  def claimed?(arcade)
    claimed_arcade_ids.include?(arcade.id)
  end
  
  def claimed_arcade_ids
    @cached_claimed_arcade_ids ||= claims.find(:all, :select => :arcade_id, :conditions => {:approved => 1}).collect(&:arcade_id)
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
  
  
  
  
  
  # Messaging
  def can_send_messages
    user.can_send_messages
  end
  
  def unread_messages?
    unread_messages_count > 0
  end
  
  def messages?
    messages_count > 0
  end
  
  
  
  
    
  def validate
    if address && !address.valid?
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
  
  
    
  
  
  protected
  def fix_http str
    return '' if str.blank?
    str.starts_with?('http') ? str : "http://#{str}"
  end
  
  def reset_permalink
    permalink = nil if display_name_changed?
  end
end
