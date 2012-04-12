class Category < ActiveRecord::Base
  
  has_many :post_categories
  has_many :posts, :through => :post_categories
  has_ancestry
  
  validates :name, :presence => true, :length => { :within => 3..255 }, :uniqueness => true
end
