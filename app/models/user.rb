require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :posts
  has_many :votes
  has_many :comments
  has_many :tag_ownerships
  has_many :tags, :through => :tag_ownerships
  
  # Callbacks used to process the password hashing
  before_save :create_hashed_password
  after_save :clear_password
  
  # Class instance variable that is not a database attribute, used to store user supplied password
  attr_accessor :password
  
  REGEX_EMAIL = /^[a-zA-Z]([a-zA-Z0-9]*[\.\-\_]*)*[a-zA-Z0-9]*@([a-zA-Z0-9]*[\.\-\_]*)*[a-zA-Z0-9]*\.[a-zA-Z]*\.?[a-zA-Z]+$/
  
  # New validate method
  validates :name, :length => { :maximum => 60 }
  validates :username, :presence => true, :length => { :within => 6..25 }, :uniqueness => true
  validates :email, :presence => true, :length => { :maximum => 100 }, :format => REGEX_EMAIL, :uniqueness => true
  validates_confirmation_of :email, :on => :create
  
  # Only perform this validation on create to allow other attributes to be updated
  validates_presence_of :password, :on => :create
  validates_length_of :password, :within => 8..25, :on => :create
  validates_confirmation_of :password, :on => :create
  
  # Standard validation methods
  # validates_length_of :name, :maximum => 60
  # validates_presence_of :email
  # validates_length_of :email, :maximum => 100
  # validates_uniqueness_of :email
  # validates_format_of :email, :with => REGEX_EMAIL
  # validates_confirmation_of :email
  # validates_presence_of :username
  # validates_length_of :username, :within => 8..25
  # validates_uniqueness_of :username
  
  scope :named, lambda {|uname| where(:username => uname)}
  scope :sorted, order("users.username ASC")
  
  # password and salt do not get directly added from user input forms
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
    
  # Methods below here are only accessible to this model
  private
  
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
  
end
