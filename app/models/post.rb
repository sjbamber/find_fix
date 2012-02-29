class Post < ActiveRecord::Base
  
  belongs_to :user
  has_many :comments
  has_many :votes
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :error_messages
  
end
