require 'digest/sha1'

class User < ActiveRecord::Base
  #Relationships
  has_many :posts
  has_many :solutions
  has_many :votes
  has_many :comments
  has_many :tag_ownerships
  has_many :tags, :through => :tag_ownerships
  
  # Callbacks used to process the password hashing
  before_save :create_hashed_password
  after_save :clear_password
  
  # Call back to downcase and remove leading and trailing whitespace
  before_validation :downcase_email, :downcase_username, :strip_name
  
  # Class instance variable that is not a database attribute, used to store user supplied password
  attr_accessor :password
  # used to store determine whether the password should be validated
  attr_accessor :update_password
  # used to validate the confirmation of terms of service
  attr_accessor :confirm_terms
  
  
  # Validations
  # Regular expressions to validate email and username format
  REGEX_EMAIL = /\A[a-zA-Z]([a-zA-Z0-9]*[\.\-\_]*)*[a-zA-Z0-9]*@([a-zA-Z0-9]*[\.\-\_]*)*[a-zA-Z0-9]*\.[a-zA-Z]*\.?[a-zA-Z]+\z/
  REGEX_USERNAME = /\A[A-Za-z][A-Za-z0-9._]*\z/
  validates :name, :length => { :maximum => 60 }
  
  validates_presence_of :username
  with_options :allow_blank => true do |v|
    v.validates_length_of :username, { :within => 6..25 }
    v.validates_format_of :username, :with => REGEX_USERNAME
    v.validates_uniqueness_of :username
  end
  
  validates_presence_of  :email
  with_options :allow_blank => true do |v|
    v.validates_length_of :email, { :maximum => 100 }
    v.validates_format_of :email, :with => REGEX_EMAIL
    v.validates_uniqueness_of :email
  end
  
  # Conditional validations
  validates_confirmation_of :email, :on => :create
  validates_acceptance_of :confirm_terms, :on => :create

  validates_presence_of  :password, :if => :should_validate_password?
  with_options :allow_blank => true do |v|
    v.validates_length_of :password, :within => 8..25, :if => :should_validate_password?
    v.validates_confirmation_of :password, :if => :should_validate_password?
  end
  
  # Custom Scopes
  scope :named, lambda {|uname| where(:username => uname)}
  scope :sorted, order("users.username ASC")
  
  # Password and salt do not get directly added from user input forms so are protected from mass-assignment
  attr_protected :role, :hashed_password, :salt
  
  # Class method to create a salt that is unique (using the username of a user), pseudo random (using Kernel::srand) and hashed (using SHA1 hash)
  def self.create_salt(username="")
    Digest::SHA1.hexdigest("#{username} and #{Kernel::srand}")
  end
  
  # Class method that performs SHA1 hashing on a salted password string
  def self.salt_and_hash(password="", salt="")
    Digest::SHA1.hexdigest("#{salt} and #{password}")
  end
 
  # Class method that authenticates a supplied username and password against the database
  def self.authenticate(username="", password="")
    user = User.find_by_username(username)
    if user && user.hashed_password == User.salt_and_hash(password, user.salt)
      return user
    else
      return false
    end
  end
  
  # Method to send an email for password reset purposes
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  # Method for generating a unique token on an attribute
  def generate_token(attribute)
    begin
      self[attribute] = SecureRandom.urlsafe_base64
    end while User.exists?(attribute => self[attribute])
  end
    
  # Methods below here are only accessible to this model
  private
  
  # Method to determine when the password should be validated
  def should_validate_password?
    # Validate when the update_password variable is set or a new record is being created
    update_password || new_record?
  end
  
  def create_hashed_password
    # Whenever :password has a value hashing is needed
    unless password.blank?
      # always use "self" when assigning values
      self.salt = User.create_salt(username) if salt.blank?
      self.hashed_password = User.salt_and_hash(password, salt)
    end
  end

  def clear_password
    # for security reasons and for updates to other fields hashing is not needed
    self.password = nil
  end 
  
  def downcase_email
    self.email = self.email.downcase.strip if self.email.present?
    self.email_confirmation = self.email_confirmation.downcase.strip if self.email_confirmation.present?
  end

  def downcase_username
    self.username = self.username.downcase.strip if self.username.present?
  end
  
  def strip_name
    self.name = self.name.strip if self.name.present?
  end
  
end
