require 'digest/sha1'
require 'digest/md5'

class User < ActiveRecord::Base
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  has_one :profile
  
  # Validation
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "is taken. Do you already have an account here? <a href=\"/signin\">Yes i do!</a>"
  validates_format_of :email, :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'does not look like an email address.'
  validates_length_of :email, :within => 3..100    
  validates_confirmation_of :email,                      :if => :email_required?

  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  
  before_save :encrypt_password
  before_create :make_activation_code

  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )

  attr_accessible :password, :password_confirmation, :email

  before_save :cascade_changes


  # Errors that a user can return
  class ActivationCodeNotFound < StandardError; end
  class AlreadyActivated < StandardError
    attr_reader :user, :message;
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end


  def make_administrator!
    update_attribute(:administrator, true)
    profile.update_attribute(:administrator, true)
  end



  # User Activation
  
  # Activates the user in the database. For the remainder of the life of this object it will be in a status of pending.
  def activate
    @activated = true
    update_attributes({:activated_at => Time.now.utc, :activation_code => nil})
    save!
    
    profile.active = true
    profile.save!
  end

  # Finds the user with the corresponding activation code, activates their account and returns the user.
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
    !activated_at.nil?
  end
  
  # Returns true if the user has just been activated.
  def pending?
    @activated
  end
  
  def requested_signup_notification
    @requested_signup = true
  end
    
  def recently_requested_signup_notification?
    @requested_signup
  end
  
  def self.find_for_forget(_email)
    find :first, :conditions => ['email = ? and activation_code IS NULL', _email]
  end
  
  def change_password(current_password, new_password, confirm_password)
    
    sp = encrypt(current_password)
    errors.add(:verify_password, "The password you supplied is not the correct password.") and
      return false unless sp == self.crypted_password
    
    self.password = new_password
    self.password_confirmation = confirm_password

    return false unless self.valid?
    self.save!
  end
  
  
  
  
  
  


  # Authentication
  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  def self.authenticate(_email, _password)
    user = User.find(:first, :conditions => ['email = ? and activated_at IS NOT NULL', _email])
    user && user.authenticated?(_password) ? user : nil
  end

  # Encrypts the password with the user salt
  def encrypt(_password)
    Digest::SHA1.hexdigest("--#{salt}--#{_password}--")
  end

  # This will check if the current users password matches the one provided.
  def authenticated?(_password)
    crypted_password == encrypt(_password)
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # Remember options
  # This will determine if the user has selected the "remember me" option, and whether or not their token has since expired.
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
  
  
  
  
  
  
  
  
  
  
  # Reset Password
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

  def forgot_password
    @forgotten_password = true
    make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end  
  






  def validate
    if profile && !profile.valid?
      profile.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
  
  
  # Since email is used so much across the site, make it easier by storing it in both places
  def cascade_changes
    profile[:email] = email if email_changed?
  end
  
  def cascade_create_changes
    profile.active = false
  end



  
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{password}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || (!password.nil? || !password_confirmation.nil?)
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

      profile.active = true
      profile.save!
    end
    
    def email_required?
      email_changed? || email.blank? || !email_confirmation.nil?
    end

end