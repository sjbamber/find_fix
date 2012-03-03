class Post < ActiveRecord::Base
  
  belongs_to :user
  has_many :comments
  has_many :votes
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :error_messages
  
  validates_presence_of :post_type
  validates_length_of :title, :maximum => 255
  validates_presence_of :description
  
  # validates_presence_of :categories
  # validates_associated :categories
  
  # validates_presence_of :tags
  # validates_associated :tags
  
  # post type does not get added from user input forms
  attr_protected :post_type
  
  scope :sorted, order("posts.updated_at ASC")
  scope :search, lambda {|query| where(["title LIKE ?", "%#{query}%"])}
  
end
