class Post < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  has_many :solutions
  has_many :comments
  has_many :votes
  
  has_many :post_tags
  has_many :tags, :through => :post_tags

  has_many :post_categories
  has_many :categories, :through => :post_categories

  has_many :post_error_messages
  has_many :error_messages, :through => :post_error_messages
  
  attr_accessor :validate_nested
  
  # Accept nested attributes, enables nested assignment using fields for
  # :reject_if => lambda {|a| a[:name].blank?} # ignores blank entries
  accepts_nested_attributes_for :tags, :categories, :reject_if => lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :error_messages, :reject_if => lambda {|a| a[:description].blank?}
  accepts_nested_attributes_for :comments, :votes

  # Validation
  validates_presence_of :title, :description
  validates_length_of :title, :maximum => 255
  
  # Validations for tags and categories
  validates_presence_of :tags, :if => :validate_nested
  validates_presence_of :categories, :if => :validate_nested

  # validates_presence_of :tags, :on => :create
  # validates_presence_of :categories, :on => :create
  validates_associated :tags, :categories, :error_messages
  
  # Sets pagination value
  self.per_page = 10
  
  # Custom Scopes
  scope :sorted, order("posts.updated_at ASC")  
  scope :search, lambda {|query| where(["title LIKE ?", "%#{query}%"])}
  
end
