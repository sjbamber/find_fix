class Post < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  has_many :comments
  has_many :votes
  
  has_many :post_tags
  has_many :tags, :through => :post_tags

  has_many :post_categories
  has_many :categories, :through => :post_categories

  has_many :post_error_messages
  has_many :error_messages, :through => :post_error_messages
  
  accepts_nested_attributes_for :post_tags, :post_categories, :post_error_messages, :reject_if => lambda {|a| a[:post_id].blank?}
  accepts_nested_attributes_for :tags, :categories, :reject_if => lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :error_messages, :reject_if => lambda {|a| a[:description].blank?}
  accepts_nested_attributes_for :user, :comments, :votes
  
  # :reject_if => lambda {|a| a[:name].blank?} # Reject ignores blank entries

  # Validation
  validates_presence_of :post_type, :description#, :categories, :tags, :error_messages
  validates_length_of :title, :maximum => 255
  
  # validates_presence_of :error_messages
  # validates_presence_of :categories
  # validates_associated :categories
  
  # validates_presence_of :tags
  # validates_associated :tags
  
  # post type does not get added from user input forms
  attr_protected :post_type
  
  # Custom Scopes
  
  scope :sorted, order("posts.updated_at ASC")
  scope :search, lambda {|query| where(["title LIKE ?", "%#{query}%"])}
  
end
