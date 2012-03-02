class Category < ActiveRecord::Base
  
  has_and_belongs_to_many :posts
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..255
  validates_uniqueness_of :name
  
end
