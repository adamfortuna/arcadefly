require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  has_many :frequentships
  has_many :permissions
  has_many :arcades, :through => :frequentships
  has_many :roles, :through => :permissions
  has_one :address, :as => :addressable 
    
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 6..100
  validates_uniqueness_of   :login, :case_sensitive => false, :message => 'is already taken. Please choose another login.'
  validates_uniqueness_of   :email, :case_sensitive => false, :message => 'is already taken. Do you already have an account here?'
  validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
  
  validates_associated :address
  
  before_save :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  class ActivationCodeNotFound < StandardError; end
  class AlreadyActivated < StandardError
    attr_reader :user, :message;
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end

  # Activates the user in the database. For the remainder of the life of this object it will be in a status of pending.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Finds the user with the corresponding activation code, activates their account and returns the user.
  #
  # Raises:
  #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
  #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
    raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
    raise ActivationCodeNotFound if !user
    raise AlreadyActivated.new(user) if user.active?
    user.send(:activate!)
    user
  end
  
  # This checks to see if the user is activated.
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Returns true if the user has just been activated.
  def pending?
    @activated
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  # This will check if the current users password matches the one provided.
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  # This will determine if the user has selected the "remember me" option, and whether or not
  # their token has since expired.
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def create_reset_code
    @reset_password = true
    make_reset_code
    save(false)
   end

  def recently_reset_password?
    @reset_password
  end

  def recently_forgot_password?
    @forgotten_password
  end
  
  def delete_reset_code
    self.password_reset_code = nil
    save(false)
  end
# end From

# Address related
  #def address=(attributes)
  #  address = build_address if !address
  #  address.attributes = attributes
  #end
  
  def has_address?
    address && (!address.nil? || address.new_record?)
  end
  
  def country_id
    address.country.id
  end
  
  def region_id
    address.region.id
  end
# End address related

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  # Role based
  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end  
  
  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activation_code IS NULL', email]
  end
  
  def has_role?(rolename)
    self.roles.find_by_rolename(rolename) ? true : false
  end
  
  def to_param
    login
  end
  
  def validate
    if address && !address.valid?
      address.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    # Create a timestamp for remembering based on a length of time from now.
    def remember_me_for(time)
      remember_me_until time.from_now.utc
    end

    # Create 
    def remember_me_until(time)
      self.remember_token_expires_at = time
      self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
      save(false)
    end
    
  private
    def activate!
      @activated = true
      self.activated_at = Time.now.utc
      self.activation_code = nil
      self.save!
    end
end
