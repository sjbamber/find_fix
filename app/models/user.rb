class User < ActiveRecord::Base
  
  has_many :posts
  has_many :votes
  has_many :comments
  has_and_belongs_to_many :tags
  
end
