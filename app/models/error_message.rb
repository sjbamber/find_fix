class ErrorMessage < ActiveRecord::Base
  
  has_many :post_error_messages
  has_many :posts, :through => :post_error_messages
  
  validates :description, :presence => true, :length => { :within => 3..255 }
  
end
