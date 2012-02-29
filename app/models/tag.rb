class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :users
  
end
