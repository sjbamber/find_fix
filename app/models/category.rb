class Category < ActiveRecord::Base
  
  has_many :post_categories
  has_many :posts, :through => :post_categories
  has_ancestry
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..255
  validates_uniqueness_of :name
    
end
