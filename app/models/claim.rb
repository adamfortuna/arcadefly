class Claim < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :arcade
  belongs_to :profile
  
  named_scope :approved, :conditions => ['approved = ?', true]
  named_scope :pending, :conditions => ['approved = ?', false]
  
  
  validates_presence_of :arcade, :profile, :level, :reason
  validates_length_of :reason, :minimum => 10
  
  validates_presence_of     :name,                     :if => :name_required?
  validates_length_of       :name, :within => 4..200,  :if => :name_required?
  
  
  before_destroy :send_denied_email
  attr_accessor :denied
  

  LEVELS = ["I'm the Owner/Manager at this Arcade", 1],
           ["I'm an Employee at this Arcade", 2],
           ["I live in the area and this is one of my main hangouts", 3],
           ["Just a place I go to every now and again", 4],
           ["Ive been there at least once, just trying to help", 5]

  def type
    Claim::LEVELS.rassoc(self.level)[0]
  end

  def owner?
    level == 1
  end
  
  def employee?
    level == 2
  end
  
  def player?
    level >= 3
  end
  
  def approve!
    self.transaction do
      self.update_attribute(:approved, true)
      send_approval_email
    end
  end
  
  def send_approval_email
    UserMailer.deliver_claim_approval(self)
  end
  
  def send_denied_email
    UserMailer.deliver_claim_denied(self) if !approved && denied
  end
  
  private
  def name_required?
    owner?
  end
end