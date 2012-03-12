class Tag < ActiveRecord::Base
  
  has_many :post_tags
  has_many :posts, :through => :post_tags
  
  has_many :tag_ownerships
  has_many :owners, :through => :tag_ownerships, :class_name => "User"
  
  validates :name, :presence => true, :length => { :within => 3..100 }
  
end
