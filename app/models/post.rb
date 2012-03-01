class Post < ActiveRecord::Base
  
  belongs_to :user
  has_many :comments
  has_many :votes
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :error_messages
  
  validates_presence_of :post_type
  validates_presence_of :description
  
end
